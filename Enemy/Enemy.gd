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

#Generacja losowej pozycji
var x
var y 
var generate:bool = false

var dir: Vector2 = Vector2(0,0)
var start_timer:bool = false
var change:bool = true

func _ready() -> void:
	x = randi_range(-400,400)
	y = randi_range(-400,400)
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	if generate == true:
		Generate()
	if start_timer == true:
		$another_timer.start()
	movement(delta)

func movement(delta):
	#sledzenie 
	sprite.look_at(Player.global_position)
	
	#obliczanie odległości 
	distance = Player.global_position - position
	lang = distance[1]*distance[1] + distance[0]*distance[0]
	lang = sqrt(lang)
	
	#poruszanie 
	if lang >= 400:
		generate = true
		start_timer = false
		speed = 10000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed * delta
		move_and_slide()
		
	if lang <= 300 and change == true:
		change = false
		generate = true
		start_timer = false
		speed = -10000
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed  * delta
		move_and_slide()
		
	else:
		#Poruszanie Na Boki TODO
		generate = false
		start_timer = true
		speed = 10000
		if -dir != to_local(nav_agent.get_next_path_position()).normalized():
			dir = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = dir * speed * delta
		move_and_slide()
		
func make_path():
	if lang <= 300 or lang >= 400 and change == true:
		nav_agent.target_position = Player.global_position
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
	shoot()

func shoot():
	if shoot_available:
		shoot_available = false
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $Sprite2D/Marker2D.global_transform
		shoot_timer.start()

func Generate():
	x = randi_range(-400,400)
	y = randi_range(-400,400)


func _on_another_timer_timeout() -> void:
	change = true
