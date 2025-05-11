extends Control

@onready var logo: AnimationPlayer = $logo
@onready var solpolex_logo: Control = $"Solpolex Logo"
@onready var logo_intro: AudioStreamPlayer = $"Solpolex Logo/LogoIntro"
@onready var main_menu: AudioStreamPlayer = $MainMenu


func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.button_down.connect(_on_button_down)
		button.button_up.connect(_on_button_up)
	
	if Global.play_intro == true:
		logo.play("Logo")
		logo_intro.play()
		await logo.animation_finished
		solpolex_logo.queue_free()
		logo.queue_free()
		Global.play_intro = false
		AudioManager.play_main_menu(-20)
	else:
		solpolex_logo.queue_free()
		logo.queue_free()
		AudioManager.play_main_menu(-20)
		
func _on_button_down():
	AudioManager.menu_button_down.play()

func _on_button_up():
	AudioManager.menu_button_up.play()


func _on_play_pressed() -> void:
	AudioManager.stop_music(1.0)
	Global.reset()
	Transition.transition()
	await Transition.on_transition_finished
	Global.is_in_game = true
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Settings/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Credits/credits.tscn")
