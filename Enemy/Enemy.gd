extends CharacterBody2D

@export var Bullet : PackedScene
@export var Player : CharacterBody2D
@export var shoot_timer : Timer

@onready var nav_agent := $NavigationAgent2D as  NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D

var speed = 5000
var distance : Vector2i
var lang : int
var shoot_available : bool

func _ready() -> void:
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta):
	#sledzenie 
	sprite.look_at(Player.global_position)
	
	#obliczanie odległości 
	distance = Player.global_position - position
	lang = distance[1]*distance[1] + distance[0]*distance[0]
	lang = sqrt(lang)
	
	#poruszanie 
	if lang > 300:
		speed = 10000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed * delta
		move_and_slide()
		
	if lang < 300:
		speed = -10000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed  * delta
		move_and_slide()
		
	if is_zero_approx(lang):
		speed = 0 

func make_path():
	nav_agent.target_position = Player.global_position

func _on_timer_timeout() -> void:
	make_path()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		speed = 0 

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		speed = 10000

func can_shoot() -> void:
	shoot_available = true
	shoot()

func shoot():
	if shoot_available:
		shoot_available = false
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $Sprite2D/Marker2D.global_transform
		shoot_timer.start()
