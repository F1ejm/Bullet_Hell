extends Marker2D


@export var obstacle : PackedScene


func _ready() -> void:
	var b = obstacle.instantiate()
	add_child(b)
	b.global_position = global_position
