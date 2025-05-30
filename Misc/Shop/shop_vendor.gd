extends StaticBody2D

var shop_open := false

func _ready() -> void:
	rotation = rotation - global_rotation

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.shop_can_interact = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.shop_can_interact = false

func _process(delta: float) -> void:
	global_rotation = 0 
	if Global.shop_can_interact == true:
		Global.show_interaction = true
	else:
		Global.show_interaction = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and Global.shop_can_interact == true:
		Global.Shop1 = true
		if shop_open == false:
			shop_open = true
			Global.stop = true
			Global.shop_ui_visible = true
		else:
			shop_open = false
			Global.stop = false
			Global.shop_ui_visible = false
