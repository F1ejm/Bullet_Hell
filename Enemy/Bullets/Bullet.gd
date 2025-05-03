extends Area2D

@export var speed = 500

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.IsDashing == false:
		#Particle i sound effecty Obrażeń TODO
		Global.Zycie -= 1
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()
