extends "res://Scenes/Towers/Turrets.gd"





func _on_Muzzle_ready():
	muzzle_path = self.get_node("Turret/Missile1/Muzzle")

