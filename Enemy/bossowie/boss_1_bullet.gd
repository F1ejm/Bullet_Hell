extends Area2D

var speed = 700

#sideways movement
var fall_speed = 150
var directon: bool = true
@onready var timer: Timer = $Timer
var move_side: bool
var change_timer: bool

func _ready() -> void:
	if change_timer == true:
		timer.wait_time = randf_range(0.5,1.5)

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	if move_side == true:
		if directon == true:
			position += Vector2.UP.rotated(rotation) * fall_speed * delta
		else:
			position += Vector2.DOWN.rotated(rotation) * fall_speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.dash_immunity == false and Global.immune == false:
		#Particle i sound effecty Obrażeń TODO
		body.Dmg_Func(1)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()


func _on_timer_timeout() -> void:
	if directon == true:
		directon = false
	else:
		directon = true


func _on_queue_free_timer_timeout() -> void:
	queue_free()
