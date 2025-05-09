extends Area2D

var Player: CharacterBody2D
var main:Node2D

var initial_speed = 150

@onready var atak_timer: Timer = $atak_timer
var timer_waittime: float
var missile_speed = 1000

var missile: bool = false


func _physics_process(delta: float) -> void:
	if missile == false:
		position += Vector2.RIGHT.rotated(rotation) * initial_speed * delta
	else:
		position += Vector2.RIGHT.rotated(rotation) * missile_speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.dash_immunity == false and Global.immune == false:
		#Particle i sound effecty Obrażeń TODO
		body.Dmg_Func(1)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()


func _on_queue_free_timer_timeout() -> void:
	queue_free()


func _on_atak_timer_timeout() -> void:
	var x = global_transform
	get_parent().remove_child(self)
	main.add_child(self)
	global_transform = x
	missile = true
	look_at(Player.global_position)
