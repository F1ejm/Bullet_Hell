extends StaticBody2D

var shop_open := false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.show_shopkeeper = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.show_shopkeeper = false

func _process(delta: float) -> void:
	if Global.show_shopkeeper == true:
		Global.show_interaction = true
	else:
		Global.show_interaction = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and Global.show_shopkeeper == true:
		if shop_open == false:
			shop_open = true
			Global.stop = true
			Global.shopkeeper_ui_visible = true
		else:
			shop_open = false
			Global.stop = false
			Global.shopkeeper_ui_visible = false
