extends Control


func _on_play_pressed() -> void:
	Global.is_in_game = true
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Settings/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Credits/credits.tscn")
