extends CharacterBody2D

@export var Bullet : PackedScene
@export var Player : CharacterBody2D
@export var shoot_timer : Timer
@export var Marker : Marker2D

@onready var nav_agent := $NavigationAgent2D as  NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D

var speed = 5000
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
	#movement(delta)
	sprite.look_at(Player.global_position)
	Marker.rotation +=0.1

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
		speed = 10000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed * delta
		move_and_slide()
		
	if lang < 270:	
		generate = true
		speed = 10000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed * delta
		move_and_slide()
		
	elif lang > 300 and lang < 500:
		#Poruszanie Na Boki TODO
		generate = false
		speed = 10000
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
	marker_rot()

func shoot():
	if shoot_available :
		shoot_available = false
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.global_rotation = Marker.global_rotation


func marker_rot():
	var marker  = Marker.global_transform
	print("as")
	for i in range(0,100,10):
		Marker.rotation +=i
		shoot()
	Marker.global_rotation = marker
	shoot_timer.start()

func Generate():
	x = randi_range(-400,400)
	y = randi_range(-400,400)
