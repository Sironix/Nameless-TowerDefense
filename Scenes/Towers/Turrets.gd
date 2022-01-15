extends Node2D

var enemy_array = []
var enemy

var ready = true
var built = false

var type
var category
var projectile
var self_range
var shotspeed
var damage
var rate
var pierce
var muzzle_path

func setup(build_type,location):
	position = location
	built = true
	type = build_type
	category = GameData.tower_data[type]["category"]
	self_range = GameData.tower_data[type]["range"]
	damage = GameData.tower_data[type]["damage"]
	rate = GameData.tower_data[type]["rate"]
	if category != "instant":
		projectile = GameData.tower_data[type]["projectile"]
		shotspeed = GameData.tower_data[type]["shotspeed"]
		pierce = GameData.tower_data[type]["pierce"]
func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").scale = Vector2(	(self_range + 0.5), (self_range + 0.5) )

func _physics_process(delta):
	if enemy_array.size() > 0 and built:
		select_enemy()
		if category == "instant":
			if not get_node("AnimationPlayer").is_playing():
				turn()
		else:
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
	
	
	yield(get_tree().create_timer(rate), "timeout")
	ready = true

func fire_instant():
	get_node("AnimationPlayer").play("Fire")
	enemy.on_hit(damage)
	
func fire_projectile():
	var new_shot = load("res://Scenes/Towers/" + projectile + ".tscn").instance()
	var muzzle_position = self.position + Vector2(32,32) + muzzle_path.position.rotated(self.get_node("Turret").rotation)
	new_shot.setup(shotspeed,self.get_node("Turret").rotation,self_range,muzzle_position,damage,pierce)
	GameData.GameScene_Path.get_node("Projectiles").add_child(new_shot, true)


func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
