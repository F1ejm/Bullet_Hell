extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and get_tree().get_nodes_in_group("Enemy").is_empty():
		$"../../AnimationPlayer".play("open")
		queue_free()
