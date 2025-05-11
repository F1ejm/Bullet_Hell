extends Control

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.button_down.connect(_on_button_down)
		button.button_up.connect(_on_button_up)

func _on_button_down():
	AudioManager.menu_button_down.play()

func _on_button_up():
	AudioManager.menu_button_up.play()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and Global.is_in_game == true:
		Global.is_in_game = false
		Global.is_in_pause_menu = true
	elif event.is_action_pressed("back") and Global.is_in_pause_menu == true and Global.is_in_settings == false:
		Global.is_in_game = true
		Global.is_in_pause_menu = false

func _process(delta: float) -> void:
	if Global.is_in_settings == true:
		visible = false
	elif Global.is_in_settings == false and Global.is_in_pause_menu == true:
		visible = true
	elif Global.is_in_settings == false and Global.is_in_pause_menu == false:
		visible = false


func _on_resume_pressed() -> void:
	Global.is_in_pause_menu = false
	Global.is_in_game = true

func _on_settings_pressed() -> void:
	Global.is_in_settings = true
	Global.is_in_pause_menu = false

func _on_main_menu_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	Global.is_in_game = false
	Global.is_in_pause_menu = false
	Global.is_in_settings = false
	get_tree().change_scene_to_file("res://UI/Main Menu/main_menu.tscn")
