extends Node

func _ready():
	load_main_menu()

func on_newgame_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", self, "unload_game")
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()

func unload_game(result):
	get_node("GameScene").queue_free()
	var main_menu = load("res://Scenes/UIScenes/MainMenu.tscn").instance()
	add_child(main_menu)
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	load_main_menu()

func load_main_menu():
# warning-ignore:return_value_discarded
	get_node("MainMenu/MarginContainer/VBoxContainer/NewGame").connect("pressed", self, "on_newgame_pressed")
# warning-ignore:return_value_discarded
	get_node("MainMenu/MarginContainer/VBoxContainer/Quit").connect("pressed", self, "on_quit_pressed")
