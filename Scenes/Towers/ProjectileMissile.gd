extends Area2D

var traveled_amount = 0
var enemy_array = []

var speed 
var velocity
var base_range
var damage
var pierce


func setup(tower_speed,tower_rotation,tower_range,tower_position,tower_damage,tower_pierce):
	speed = tower_speed
	self.rotation= tower_rotation
	base_range = tower_range
	damage = tower_damage
	pierce = tower_pierce
	self.position = tower_position
	velocity = Vector2(1, 0).rotated(rotation) * speed

func _physics_process(delta):
	position += velocity * delta
	traveled_amount += speed * delta
	if traveled_amount >= ((base_range + 0.5)/10)*620*1.25:
		destroy()


func destroy():
	queue_free()


func _on_Projectile_body_entered(body):
	enemy_array.append(body.get_parent())
	if enemy_array.size() > 1:
		for i in enemy_array:
			enemy_array[i].on_hit(damage)
			pierce -=1
			if pierce <= 0:
				destroy()
				break
	elif enemy_array.size() == 1:
			enemy_array[0].on_hit(damage)
			pierce -=1
			if pierce <= 0:
				destroy()
	enemy_array=[]
