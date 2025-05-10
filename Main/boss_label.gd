extends Label

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - Vector2(300,0)
	if Global.label_boss == true:
		visible = true
	else:
		visible = false
