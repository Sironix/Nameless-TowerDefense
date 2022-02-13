extends Node2D

signal game_finished(result)

var map_node

#-------Build mode logic-----------
var build_mode = false
var build_valid = false
var build_base_rotation
var build_location
var build_type
var build_tile

#------Selection Logic--and---Upgrade Menu---------
var selected_tower
var displaying_upgrade_menu = false

#-------Wave Logic--------
var current_wave
var enemies_in_wave = 0
var wave_value = 0
var base_health
var base_money = 300
var wave_state = "idle"

#----Functions start here-----


func _ready():
	map_node = get_node("Map") ## turn this into the selected map.

	GameData.GameScene_Path = map_node
	
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
	if event.is_action_released("ui_cancel") and displaying_upgrade_menu == true:
		cancel_tower_selection()
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()


#=====================================
#			Wave Functions
#=====================================

func start_next_wave():
	current_wave +=1
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2),"timeout") ## time between waves
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = GameData.wave_data[current_wave]
	enemies_in_wave = 0
	for i in wave_data:
		var enemies
		if i.size() >= 4: enemies= i[3]
		else: enemies = 1
		enemies_in_wave += enemies
		print ("enemies in this wave = ", enemies_in_wave)
	return wave_data

func spawn_enemies(wave_data):
	wave_state = "Spawning"
	var id = 0
	for i in wave_data:
		
		var loops
		if i.size() >= 4: loops= i[3]
		else: loops = 1
		
		for n in range(0,loops,1):
    
			var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
			new_enemy.connect("base_damage", self, "on_base_damage")
			new_enemy.connect("enemy_deleted", self, "on_enemy_deleted")
			new_enemy.connect("award_money", self, "on_award_money")
			if i[0] == "TieredEnemy":
				new_enemy.setup(i[1])
			map_node.get_node("Path").add_child(new_enemy, true)
			new_enemy.id = id
			
			yield(get_tree().create_timer(i[2]),"timeout")
			id +=1
		wave_state ="idle"



func wave_finished():
	print("Congratz on beating wave ",current_wave)
	if Engine.get_time_scale() == 2.0:
		if enemies_in_wave == 0 and wave_state == "idle":
			start_next_wave()
	else:
		get_node("UI").update_pause_button()

#=====================================
#		Tower Selection Functions
#=====================================


func select_tower(tower):
#	deselect previous tower
	if displaying_upgrade_menu==true:
		selected_tower.getting_deselected()
	
#	select new tower
	selected_tower = tower
	
#	name change
	$"UI/HUD/Upgrade Menu/VBoxContainer/Name Container/Tower Name Value".text = selected_tower.type
#	stat changes
	$"UI/HUD/Upgrade Menu/VBoxContainer/Stat Spacer/VBox Stats/HBox Stat 1/Container/Stat 1 Name".text = selected_tower.display_stat_1
	$"UI/HUD/Upgrade Menu/VBoxContainer/Stat Spacer/VBox Stats/HBox Stat 1/Container2/Stat 1 Value".text = str(selected_tower[selected_tower.display_stat_1])
	$"UI/HUD/Upgrade Menu/VBoxContainer/Stat Spacer/VBox Stats/HBox Stat 2/Container/Stat 2 Name".text = selected_tower.display_stat_2	
	$"UI/HUD/Upgrade Menu/VBoxContainer/Stat Spacer/VBox Stats/HBox Stat 2/Container2/Stat 2 Value".text = str(selected_tower[selected_tower.display_stat_2])
	$"UI/HUD/Upgrade Menu/VBoxContainer/Stat Spacer/VBox Stats/HBox Stat 3/Container/Stat 3 Name".text = selected_tower.display_stat_3	
	$"UI/HUD/Upgrade Menu/VBoxContainer/Stat Spacer/VBox Stats/HBox Stat 3/Container2/Stat 3 Value".text = str(selected_tower[selected_tower.display_stat_3])
#	make the ui visible
	get_node("UI/HUD/Upgrade Menu").visible= true
	displaying_upgrade_menu = true

func cancel_tower_selection():
	displaying_upgrade_menu = false
	get_node("UI/HUD/Upgrade Menu").visible = false
	selected_tower.getting_deselected()

func _on_Upgrade_Button_1_pressed():
	print("upgrade 1")


func _on_Upgrade_Button_2_pressed():
	print("upgrade 2")


func _on_Upgrade_Button_3_pressed():
	print("upgrade 3")


func _on_Sell_Button_pressed():
	print("selling tower")
# remember to empty the "selected_tower" variable 
# and to close the upgrade menu 

#=====================================
#			Building Functions
#=====================================


func initiate_build_mode(tower_type):
	if displaying_upgrade_menu:
		cancel_tower_selection()
	if build_mode:
		cancel_build_mode()
	build_type = tower_type
	build_mode = true
	get_node("UI").set_tower_preview(build_type,get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_world(current_tile)
#	check if map tile is empty and you have enough money for the tower
	var x = current_tile[0]
	var y = current_tile[1]
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1 \
		and map_node.get_node("Ground").get_cellv(current_tile) == -1 \
		and (map_node.get_node("Ground").get_cell(x-1,y) != -1
			or map_node.get_node("Ground").get_cell(x+1,y) != -1
			or map_node.get_node("Ground").get_cell(x,y-1) != -1
			or map_node.get_node("Ground").get_cell(x,y+1) != -1) \
		and base_money >= GameData.tower_data[build_type]["price"]:
		get_node("UI").update_tower_preview(tile_position,"ad54ff3c")
		
		if map_node.get_node("Ground").get_cell(x-1,y) != -1: build_base_rotation = 180
		elif map_node.get_node("Ground").get_cell(x,y-1) != -1: build_base_rotation = 270
		elif map_node.get_node("Ground").get_cell(x,y+1) != -1: build_base_rotation = 90
		else: build_base_rotation = 0
		
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
			new_tower.setup(build_type,build_location)
			map_node.get_node("Turrets").add_child(new_tower, true)
			map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)
			
			new_tower.get_node("Base").set_rotation_degrees(build_base_rotation)
			new_tower._ready()
			base_money -= GameData.tower_data[build_type]["price"]
			get_node("UI").update_money_bar(base_money)


#=====================================
#			Etc
#=====================================

func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		get_node("UI").update_health_bar(base_health)

func on_enemy_deleted(type_of_deletion,unit_name , id):
	print(type_of_deletion," ", " ",unit_name," ", id)
	yield(get_tree().create_timer(0.25),"timeout")
	enemies_in_wave = map_node.get_node("Path").get_child_count()


	if enemies_in_wave == 0 and wave_state == "idle":

		yield(get_tree().create_timer(1.2),"timeout") 
		wave_finished()

func on_award_money(amount):
	base_money += amount
	get_node("UI").update_money_bar(base_money)
