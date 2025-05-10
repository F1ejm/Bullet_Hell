extends Area2D

	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.label_boss = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.label_boss = false
