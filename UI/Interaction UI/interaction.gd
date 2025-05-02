extends Control

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Global.show_interaction == true:
		visible = true
	else:
		visible = false
