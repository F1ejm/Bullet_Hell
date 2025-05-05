extends Area2D

var speed = 200

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.IsDashing == false and Global.immune == false:
		#Particle i sound effecty Obrażeń TODO
		body.Dmg_Func(1)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
