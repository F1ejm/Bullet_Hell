extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Wall"):
		Global.can_spawn = false
	else : 
		Global.can_spawn = true
