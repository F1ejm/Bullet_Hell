extends CharacterBody2D

@export var Bullet : PackedScene
@onready var Player : CharacterBody2D = Global.player_main
@export var shoot_timer : Timer

var main: Node2D

@onready var nav_agent := $NavigationAgent2D as  NavigationAgent2D
@export var nav_timer : Timer
@onready var sprite: Sprite2D = $Sprite2D

var speed = 3000
var distance : Vector2i
var lang : int
var shoot_available : bool

#Generacja losowej pozycji
var x
var y 
var generate:bool = false

var dir: Vector2 = Vector2(0,0)

#Health
var health:int = 1
@onready var progress_bar: ProgressBar = $ProgressBar

var f = true

func _ready() -> void:
	x = randi_range(-400,400)
	y = randi_range(-400,400)
	shoot_timer.start()
	
	progress_bar.max_value = health
	
	nav_agent.target_position = Player.global_position

func _physics_process(delta: float) -> void:
	Player = Global.player_main
	progress_bar.value = health
	if health <= 0:
		Death()
	if generate == true:
		Generate()
	
	movement(delta)

func movement(delta):
	#poruszanie 
	if !nav_agent.is_target_reached():
		var nav_point_direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed * delta
		move_and_slide()

func _on_nav_timer_timeout() -> void:
	if nav_agent.target_position != Player.global_position:
		nav_agent.target_position = Player.global_position
	nav_timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.Dash_PowerUp == true and Global.IsDashing == true:
			Death()
		speed = 0 

func can_shoot() -> void:
	shoot_available = true
	shoot()

func shoot():
	if shoot_available and lang > 150:
		shoot_available = false
		var b = Bullet.instantiate()
		main.add_child(b)
		b.global_transform = $Sprite2D/Marker2D.global_transform
		shoot_timer.start()
		b.scale.x = 0.5
		b.scale.y = 0.5


func Generate():
	x = randi_range(-400,400)
	y = randi_range(-400,400)
	
func Death():
	#Animacja Smierci i SFX TODO
	Global.i -= 1
	var monetki = randi_range(0,2)
	Global.VDolce += monetki
	queue_free()
