extends Control

func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	if Global.is_in_settings == true:
		visible = true
	else:
		visible = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and Global.is_in_settings == true:
		Global.is_in_settings = false
		call_deferred("_return_to_pause_menu")

func _on_back_pressed() -> void:
	Global.is_in_settings = false
	call_deferred("_return_to_pause_menu")

func _return_to_pause_menu():
	Global.is_in_pause_menu = true
