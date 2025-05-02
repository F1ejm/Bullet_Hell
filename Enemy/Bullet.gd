extends Area2D

var speed = 500

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Wall"):
		queue_free()
