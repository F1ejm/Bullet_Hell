extends Control

@onready var logo: AnimationPlayer = $logo
@onready var solpolex_logo: Control = $"Solpolex Logo"
@onready var logo_intro: AudioStreamPlayer = $"Solpolex Logo/LogoIntro"


func _ready() -> void:
	if Global.play_intro == true:
		logo.play("Logo")
		logo_intro.play()
		await logo.animation_finished
		solpolex_logo.queue_free()
		logo.queue_free()
		Global.play_intro = false
	else:
		solpolex_logo.queue_free()
		logo.queue_free()
		

func _on_play_pressed() -> void:
	Global.is_in_game = true
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Settings/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Credits/credits.tscn")
