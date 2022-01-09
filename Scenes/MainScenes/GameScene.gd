extends Node2D

signal game_finished(result)

var map_node

var build_mode = false
var build_valid = false
var build_location
var build_type
var build_tile

var current_wave
var enemies_in_wave = 0
var wave_value = 0
var base_health
var base_money = 300

func _ready():
	map_node = get_node("Map01") ## turn this into the selected map.
	GameData.GameScene_Path = self
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode",[i.get_name()])
	
	if current_wave == null:
		current_wave = 0
	if base_health == null:
		base_health = 100
	get_node("UI").update_money_bar(base_money)


func _process(delta):
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()


#=====================================
#			Wave Functions
#=====================================

func start_next_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2),"timeout") ## time between waves
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = GameData.wave_data[current_wave]
	enemies_in_wave = wave_data.size()
	print (enemies_in_wave)
	return wave_data

func spawn_enemies(wave_data):
	var id = 0
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
		new_enemy.connect("base_damage", self, "on_base_damage")
		new_enemy.connect("enemy_deleted", self, "on_enemy_deleted")
		map_node.get_node("Path").add_child(new_enemy, true)
		new_enemy.id = id
		id +=1
		yield(get_tree().create_timer(i[1]),"timeout")

func wave_finished():
	print("Congratz on beating wave ",current_wave)
	get_node("UI").update_pause_button()
	
#=====================================
#			Building Functions
#=====================================


func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "Tier1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type,get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_world(current_tile)
	
#	check if map tile is empty and you have enough money for the tower
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1 and base_money >= GameData.tower_data[build_type]["price"]:
		get_node("UI").update_tower_preview(tile_position,"ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position,"adff4545")
		build_valid = false


func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()


func verify_and_build():
	if build_valid:
		if base_money >= GameData.tower_data[build_type]["price"]:
			var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instance()
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.category = GameData.tower_data[build_type]["category"]
			map_node.get_node("Turrets").add_child(new_tower, true)
			map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)
			new_tower._ready()
			base_money -= GameData.tower_data[build_type]["price"]
			get_node("UI").update_money_bar(base_money)


#=====================================
#			etc
#=====================================

func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		get_node("UI").update_health_bar(base_health)

func on_enemy_deleted(type_of_deletion, base_enemy_equivalent,unit_name , id):
	print(type_of_deletion," ", base_enemy_equivalent, " ",unit_name," ", id)
	if type_of_deletion == "escaped":
		enemies_in_wave -= 1
	if type_of_deletion == "killed":
		base_money += 1
		get_node("UI").update_money_bar(base_money)
		if base_enemy_equivalent == 1:
			enemies_in_wave -=1

	if enemies_in_wave == 0:
		yield(get_tree().create_timer(1.2),"timeout") 
		wave_finished()
