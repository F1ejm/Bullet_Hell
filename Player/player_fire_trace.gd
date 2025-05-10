extends Area2D



func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		area.owner.health -= 1
		queue_free()
	if area.is_in_group("Boss") and area.can_be_hit == true:
		area.health -= 0.08
		queue_free()
