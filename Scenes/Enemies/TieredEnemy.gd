extends PathFollow2D

signal base_damage(damage)
signal enemy_deleted(type_of_deletion)
signal award_money(amount)



var unit_name="null"
var original_tier
var current_tier
var hp = 25
var base_damage = 1
var speed = 50
var base_scale
var money
var color
var spawn 

var id
var alive = true

onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")
var instant_impact    = preload("res://Scenes/SupportScenes/InstantImpact.tscn")

func setup(tier):
	original_tier = tier
	current_tier = tier
	update_values()

func update_values():
	unit_name 	= GameData.enemy_data[current_tier]["name"]
	hp  		= GameData.enemy_data[current_tier]["health"]

	base_damage = GameData.enemy_data[current_tier]["damage"]
	speed 		= GameData.enemy_data[current_tier]["speed"]
	base_scale 	= GameData.enemy_data[current_tier]["scale"]
	money 		= GameData.enemy_data[current_tier]["money"]
	color 		= GameData.enemy_data[current_tier]["color"]
	get_node("Sprite").self_modulate = Color(color)


func _physics_process(delta):
	if unit_offset == 1.0:
		emit_signal("base_damage",base_damage)
		emit_signal("enemy_deleted", "escaped",unit_name, id)
		queue_free()
	move(delta)

func move(delta):
	set_offset(get_offset() + speed * delta)

func on_hit(damage):
	impact()
	hp -= damage
	if hp <= 0:
		if alive:
			on_destroy()
		else:
			print("I'm already dead Dood")

func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = instant_impact.instance()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	alive = false
	var tier_when_destroyed = current_tier
	if hp == 0 and current_tier > 0:
		current_tier = current_tier - 1
		emit_signal("award_money",money)
		if current_tier >= 1:
			update_values()
			alive = true
	elif hp < 0 and current_tier > 0:
		var total_money_given = 0
		current_tier += hp  #hp would be negative here, that's why we add it to tier
		
		for i in range(current_tier,tier_when_destroyed+1):
			if i >0:
				total_money_given += GameData.enemy_data[i]["money"]
		emit_signal("award_money",total_money_given)
		if current_tier > 0:
			update_values()
			alive = true
	if current_tier == 0:
		destroy_self()

func destroy_self():
	emit_signal("enemy_deleted","killed", unit_name, id)
	get_node("KinematicBody2D").queue_free()
	yield(get_tree().create_timer(0.15),"timeout")
	self.queue_free()


func spawn_children():
	var new_children = load('res://Scenes/Enemies/' + spawn + '.tscn').instance()
	get_parent().add_child(new_children)
	new_children.connect("base_damage", GameData.GameScene_Path, "on_base_damage")
	new_children.connect("enemy_deleted", GameData.GameScene_Path, "on_enemy_deleted")
	new_children.set_unit_offset(get_unit_offset())
	new_children.id = id

