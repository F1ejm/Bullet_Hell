extends StaticBody2D

@onready var UI: Control = $CanvasLayer/UI

func ready() -> void:
	
	UI.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.shop_can_interact = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.shop_can_interact = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and Global.shop_can_interact == true:
		Global.stop = true
		print("open shop")
		UI.visible = true

	if event.is_action_pressed("back") and Global.shop_can_interact == true:
		Global.stop = false
		print("close shop")
		UI.visible = false
