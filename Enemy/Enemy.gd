extends CharacterBody2D

var speed = 10000
@export var Player : Node
@onready var nav_agent := $NavigationAgent2D as  NavigationAgent2D


func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed * delta
	move_and_slide()

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
