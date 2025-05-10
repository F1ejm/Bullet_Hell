extends Node2D

var player
var pozycja = Vector2(-1898.0,-291.0)

func _ready() -> void:
	player = get_node("/root/Main/Player")

func _process(delta: float) -> void:
	for body in $Area2D.get_overlapping_bodies():
		if(body == player):
			$"../Entry/DoorContainer"._reset()
			player.position = pozycja
			queue_free()
