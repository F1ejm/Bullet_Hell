extends Node2D

var player

var a = true

func _ready() -> void:
	player = get_node("/root/Main/Player")

func _process(delta: float) -> void:
	for body in $Area2D.get_overlapping_bodies():
		if(body == player and a):
			$"../Entry/DoorContainer"._reset()
			a = false
