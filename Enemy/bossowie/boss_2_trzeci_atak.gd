extends Node2D

var Player
var speed: int = 400
var bullet_path = preload("res://Enemy/bossowie/boss_1_bullet.tscn")

@onready var node_2d: Node2D = $Node2D

func _ready() -> void:
	Pociski()
	

func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	

func Pociski():
	for i in range(1,21):
		#Spawn Bulletu
		var bullet = bullet_path.instantiate()
		add_child(bullet)
		bullet.transform = global_transform
		bullet.rotation = deg_to_rad(18 * i)
		bullet.speed = 220
		bullet.scale = Vector2(5,5)


func _on_timer_timeout() -> void:
	queue_free()
