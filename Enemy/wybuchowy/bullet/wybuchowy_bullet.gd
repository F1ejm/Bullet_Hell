extends Area2D

var speed = 500
var direction = Vector2.ZERO

# Podmień ścieżkę jeśli inna
var SMALL_BULLET_SCENE = preload("res://Enemy/wybuchowy/bullet/mały_bullet.tscn")

func _ready() -> void:
	# Połącz sygnał z już istniejącego Timer node
	$Timer.connect("timeout", Callable(self, "_explode"))
	$Timer.start() # Jeśli autostart nie włączony

func _physics_process(delta: float) -> void:
	$Sprite2D.rotation += 3 * delta  # wartość 3 = ok. 170 stopni/sek

	position += transform.x * speed * delta
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not Global.dash_immunity and not Global.immune:
		body.Dmg_Func(2)
		Global.immune = true
		queue_free()
	elif body.is_in_group("Wall"):
		_explode()
		queue_free()

func _explode() -> void:
	var directions = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN,
		Vector2(1, 1),    
		Vector2(1, -1),   
		Vector2(-1, 1),   
		Vector2(-1, -1),  
	]

	for dir in directions:
		var small_bullet = SMALL_BULLET_SCENE.instantiate()
		

		get_parent().add_child(small_bullet)
		small_bullet.global_position = global_position
		# 🧠 Upewnij się, że ten mały pocisk MA to pole `direction`
		small_bullet.direction = dir.normalized()

	queue_free()
