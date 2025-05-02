extends Control

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Global.shop_ui_visible == true:
		visible = true
	else:
		visible = false
