extends Area2D

var speed = 800

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		#Particle i sound effecty śmierci przeciwnika TODO
		body.queue_free()
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()
