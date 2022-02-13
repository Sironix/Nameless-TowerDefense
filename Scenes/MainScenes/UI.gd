extends CanvasLayer


func set_tower_preview(tower_type, mouse_poition):
	var drag_tower = load('res://Scenes/Towers/' + tower_type + '.tscn').instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32,32)
	var scaling =((GameData.tower_data[tower_type]["range"] *2) +1) * 64 / 640.0
	range_texture.scale = Vector2(scaling,scaling)
	var texture = load("res://Assets/UI/range_overlay.png") 
	range_texture.texture = texture
	range_texture.modulate = Color('ad54ff3c')
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_poition
	control.set_name("TowerPreview")
	add_child(control, true)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite").modulate = Color(color) 


#================================
#	Game Controls Functions
#================================
func _on_PausePlay_pressed():
	if get_parent().build_mode: ## Cancel build mode when clicking this button
		get_parent().cancel_build_mode()
	if get_node("HUD/GameControls/PausePlay").pressed == false:
		get_parent().enemies_in_wave = get_parent().map_node.get_node("Path").get_child_count()
		if get_parent().enemies_in_wave == 0:
			get_parent().start_next_wave()
#			get_node("HUD/GameControls/PausePlay").disabled = true


func _on_SpeedUp_pressed():
	if get_parent().build_mode: ## Cancel build mode when clicking this button
		get_parent().cancel_build_mode()
	
	if Engine.get_time_scale() == 2.0:
		get_node("HUD/GameControls/SpeedUp").modulate = Color("ffffff")
		Engine.set_time_scale(1.0)
	elif Engine.get_time_scale() == 1.0:
		get_node("HUD/GameControls/SpeedUp").modulate = Color("feb400")
		Engine.set_time_scale(2.0)

func update_pause_button():
	get_node("HUD/GameControls/PausePlay").pressed = true
#================================
#	Info Bar functions
#================================

func update_health_bar(base_health):
	get_node("HUD/InfoBar/HBox/Health").text = str(base_health)

func update_money_bar(base_money):
	get_node("HUD/InfoBar/HBox/Money").text = str(base_money)

#================================
#	Tower's upgrade menu
#================================

