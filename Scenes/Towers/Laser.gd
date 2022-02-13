extends "res://Scenes/Towers/Turrets.gd"
func _ready():
	display_stat_1= "self_range"
	display_stat_2= "rate_of_fire"
	display_stat_3= "pierce"



func _on_Muzzle_ready():
	muzzle_path = self.get_node("Turret/Muzzle")
