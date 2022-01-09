extends Node2D

var enemy_array = []
var enemy

var built = false
var self_range
var type
var category
var ready = true


func _ready():
	if built:
		self_range = GameData.tower_data[type]["range"]
		self.get_node("Range/CollisionShape2D").scale = Vector2(	(self_range + 0.5), (self_range + 0.5) )

func _physics_process(delta):
	if enemy_array.size() > 0 and built:
		select_enemy()
		if not get_node("AnimationPlayer").is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy = null

func turn():
	get_node("Turret").look_at(enemy.position)

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
			enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire():
	ready = false
	
	if category == "instant":
		fire_instant()
	elif category == "projectile":
		fire_projectile()
	
	enemy.on_hit(GameData.tower_data[type]["damage"])
	yield(get_tree().create_timer(GameData.tower_data[type]["rate"]), "timeout")
	ready = true

func fire_instant():
	get_node("AnimationPlayer").play("Fire")

func fire_projectile():
	pass

func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
