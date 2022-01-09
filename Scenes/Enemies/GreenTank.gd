extends "res://Scenes/Enemies/BaseEnemy.gd"

func _ready():
	unit_name = "GreenTank"
	hp = 30
	base_damage = 45
	speed = 100
	spawn = "RedTank"
