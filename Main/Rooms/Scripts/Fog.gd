extends Area2D

var player

var is_Player_Detected = false

func _ready() -> void:
	player = get_node("/root/Main/Player")

func _process(delta: float) -> void:
	for body in self.get_overlapping_bodies():
		if(body == player):
			is_Player_Detected = true
	if(is_Player_Detected):
		get_parent().modulate.a = get_parent().modulate.a -0.1
