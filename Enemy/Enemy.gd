extends CharacterBody2D

var speed = 50 

@export var Player : CharacterBody2D
@export var nav_agent : NavigationAgent2D


func _process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed 
	move_and_slide()
func make_path():
	nav_agent.target_position = Player.global_position
