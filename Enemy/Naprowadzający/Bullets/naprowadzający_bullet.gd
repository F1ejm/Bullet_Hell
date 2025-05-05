extends Area2D

var speed = 300
var enemy: CharacterBody2D

var dmg: int

#Immunity na chwile
var immune: bool = true

func _physics_process(delta: float) -> void:
	look_at(enemy.global_position)
	global_position += ((global_position - $Pivot.global_position) * delta * speed)
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.dash_immunity == false and Global.immune == false:
		#Particle i sound effecty Obrażeń TODO
		body.Dmg_Func(1)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()
	
	elif body.is_in_group("Enemy"):
		body.health -= dmg
		queue_free()
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy") and immune == false:
		area.owner.health -= dmg
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()


func _on_immunity_timer_timeout() -> void:
	immune = false
