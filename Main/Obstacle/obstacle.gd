extends StaticBody2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		Global.i -= 1
		Global.can_spawn += 1 
		body.queue_free()
