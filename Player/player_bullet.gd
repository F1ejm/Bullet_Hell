extends Area2D

var initial_velocity = Vector2(0,0)
var speed = 800
var dmg: int

var PowerUp_Active: bool

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	position += initial_velocity * delta / 10
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Wall"):
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		#Particle i sound effecty śmierci przeciwnika TODO
		area.owner.health -= dmg
		queue_free()
	if area.is_in_group("Bullet") and PowerUp_Active == true:
		area.queue_free()
