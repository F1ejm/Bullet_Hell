extends Area2D

var speed = 2500

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.dash_immunity == false and Global.immune == false:
		#Particle i sound effecty Obrażeń TODO
		body.Dmg_Func(1)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()
var direction = Vector2.ZERO



	
