extends Control





func _on_restart_button_up() -> void:
	AudioManager.fade_out(AudioManager.main_menu, 1.0)
	Global.reset()
	Transition.transition()
	await Transition.on_transition_finished
	Global.is_in_game = true
	get_tree().change_scene_to_file("res://Main/Main.tscn")



func _on_main_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://UI/Main Menu/main_menu.tscn")
