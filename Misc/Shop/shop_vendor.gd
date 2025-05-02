extends StaticBody2D

var can_interact: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_interact = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_interact = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact == true:
		print("open shop")
	if event.is_action_pressed("back") and can_interact == true:
		print("close shop")
