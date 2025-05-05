extends Node2D

@export var Door_Count = 1
var end = preload("res://Main/Rooms/Normal_Rooms/End.tscn")
var Door_2 = preload("res://Main/Rooms/Normal_Rooms/2dor.tscn")
var a 

func _ready():
	print("I am ready! Node name: ", name, " — Parent: ", get_parent().name)
	print("n")
	spawn()
	
func spawn() -> void:
	for i in range(0,Door_Count):
		match(randi_range(1,2)):
			1:
				a = end.instantiate()
				$DoorContainer.get_child(i).add_child(a)
			2:
				a = Door_2.instantiate()
				$DoorContainer.get_child(i).add_child(a)
