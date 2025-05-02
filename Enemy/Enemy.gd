extends CharacterBody2D


@export var Player : CharacterBody2D

@onready var nav_agent := $NavigationAgent2D as  NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D

var speed = 10000
var distance : Vector2i
var lang : int

func _physics_process(delta: float) -> void:
	
	
	
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
