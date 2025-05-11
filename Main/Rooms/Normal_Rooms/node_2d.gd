extends Node2D


var is_Player_in_room = false

func _process(delta: float) -> void:
	if Global.Czas_Rundy < 1 and is_Player_in_room:
		$"../Spawner".active=false
		queue_free()
