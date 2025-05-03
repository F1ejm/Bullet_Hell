extends CharacterBody2D

@export var Bullet : PackedScene
@export var Player : CharacterBody2D
@export var shoot_timer : Timer

@onready var nav_agent := $NavigationAgent2D as  NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D

var speed = 1500
var distance : Vector2i
var lang : int
var shoot_available : bool

#Generacja losowej pozycji
var x
var y 
var generate:bool = false

var dir: Vector2 = Vector2(0,0)

func _ready() -> void:
	x = randi_range(-400,400)
	y = randi_range(-400,400)
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	if generate == true:
		Generate()
	movement(delta)

func movement(delta):
	#sledzenie 
	sprite.look_at(Player.global_position)
	
	#obliczanie odległości 
	distance = Player.global_position - position
	lang = distance[1]*distance[1] + distance[0]*distance[0]
	lang = sqrt(lang)
	
	#poruszanie 
	if lang >= 500:
		generate = true
		speed = 5000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed * delta
		move_and_slide()
		
	if lang < 270:	
		generate = true
		speed = 5000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed * delta
		move_and_slide()
		
	elif lang > 300 and lang < 500:
		#Poruszanie Na Boki TODO
		generate = false
		speed = 5000
		if -dir != to_local(nav_agent.get_next_path_position()).normalized():
			dir = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = dir * speed * delta
		move_and_slide()
		

func make_path():
	if lang >= 500:
		nav_agent.target_position = Player.global_position
	elif lang >= 70 and lang <= 300:
		nav_agent.target_position = global_position + (global_position - Player.global_position)
	else: 
		nav_agent.target_position = Player.global_position + Vector2(x,y)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		speed = 0 

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		speed = 5000

func shoot():
	if shoot_available and lang > 150:
		shoot_available = false
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $Sprite2D/Marker2D.global_transform
		b.enemy = Player
		shoot_timer.start()

func Generate():
	x = randi_range(-400,400)
	y = randi_range(-400,400)

func _on_shoot_timer_timeout() -> void:
	shoot_available = true
	shoot()

func _on_nav_timer_timeout() -> void:
	make_path()
