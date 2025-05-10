extends Node2D


var r

func _ready() -> void:
	r = Global.Runda
	

func _process(delta: float) -> void:
	if Global.Czas_Rundy < 1 :
		queue_free()
