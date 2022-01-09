extends "res://Scenes/Enemies/BaseEnemy.gd"

func _ready():
	unit_name = "RedTank"
	hp = 20
	base_damage = 25
	speed = 75
	spawn = "BlueTank"
