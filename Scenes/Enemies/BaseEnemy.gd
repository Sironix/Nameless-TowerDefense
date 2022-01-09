extends PathFollow2D

signal base_damage(damage)
signal enemy_deleted(type_of_deletion, base_enemy_equivalent)

var unit_name="null"
var speed = 50
var hp = 1
var base_damage = 1
var spawn
var base_enemy_equivalent = 0
var id
var alive = true

onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")
var instant_impact = preload("res://Scenes/SupportScenes/InstantImpact.tscn")

func _physics_process(delta):
	if unit_offset == 1.0:
		emit_signal("base_damage",base_damage)
		emit_signal("enemy_deleted", "escaped", base_enemy_equivalent,unit_name, id)
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
	emit_signal("enemy_deleted","killed",base_enemy_equivalent, unit_name, id)
	get_node("KinematicBody2D").queue_free()
	yield(get_tree().create_timer(0.15),"timeout")
	self.queue_free()
	if not spawn == null:
		spawn_children()

func spawn_children():
	var new_children = load('res://Scenes/Enemies/' + spawn + '.tscn').instance()
	get_parent().add_child(new_children)
	new_children.connect("base_damage", GameData.GameScene_Path, "on_base_damage")
	new_children.connect("enemy_deleted", GameData.GameScene_Path, "on_enemy_deleted")
	new_children.set_unit_offset(get_unit_offset())
	new_children.id = id

#func beta_spawn_test():
#	var tier = the original name/value of the enemy
#	var health = health of the enemy
#	var money = the players money. 
#	if tier > 1:
#		if health <= 0:
# if enemy got hit for more than needed, you get the money corresponded
# and you spawn the corresponded enemy instead of the original one.
#			money = money - health 
#			if tier -1 +health >= 1:
#				spawn(tier -1 +health)

