extends Node2D

@export var Door_Count = 1
var corridor_strait = preload("res://Main/Rooms/Halls/Hall_Strait.tscn")
var corridor_right = preload("res://Main/Rooms/Halls/Hall_Corner_Right.tscn")
var corridor_left = preload("res://Main/Rooms/Halls/Hall_Corner_Left.tscn")
var a 

func _ready():
	print("I am ready! Node name: ", name, " — Parent: ", get_parent().name)
	spawn()
	
func spawn() -> void:

	for i in range(0,Door_Count):
		match(randi_range(1,1)):
			1:
				a = corridor_strait.instantiate()
				$DoorContainer.get_child(i).add_child(a)

			2:
				a = corridor_right.instantiate()
				$DoorContainer.get_child(i).add_child(a)

			3:
				a = corridor_left.instantiate()
				$DoorContainer.get_child(i).add_child(a)
