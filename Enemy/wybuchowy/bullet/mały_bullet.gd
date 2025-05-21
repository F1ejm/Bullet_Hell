extends Area2D

var speed = 600
var direction = Vector2.ZERO  # ← DODAJ TO

func _ready():
	$QueueFreeTimer.start()

func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta  # ← UŻYJ direction

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not Global.dash_immunity and not Global.immune:
		body.Dmg_Func(1)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()


func _on_queue_free_timer_timeout() -> void:
	queue_free()
