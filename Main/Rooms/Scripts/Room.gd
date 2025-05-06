extends Node2D


var corridor_strait = preload("res://Main/Rooms/Halls/Hall_Strait.tscn")
var corridor_right = preload("res://Main/Rooms/Halls/Hall_Corner_Right.tscn")
var corridor_left = preload("res://Main/Rooms/Halls/Hall_Corner_Left.tscn")
var door2 = preload("res://Main/Rooms/Normal_Rooms/2dor.tscn")
var door4 = preload("res://Main/Rooms/Normal_Rooms/4dor.tscn")
var end = preload("res://Main/Rooms/Normal_Rooms/End.tscn")
var a 
var b
var d = 0
var e = 0
var f = 2

func _ready():
	print("I am ready! Node name: ", name, " — Parent: ", get_parent().name)
	b = self
	spawn(b,true,1,false)
	print("a")
	
func spawn(DoorContainer,isRoom,Door_Count,is4door) -> void:
	if(not is4door):
		if(isRoom):
			for i in range(0,Door_Count):
				match(randi_range(1,6)):
					1,2,3,4:
						a = corridor_strait.instantiate()
						DoorContainer.get_child(i).add_child(a)
						b = a.get_child(a.get_child_count()-1)
						e=e+1
						spawn(b,false,1,false)

					5:
						a = corridor_right.instantiate()
						DoorContainer.get_child(i).add_child(a)
						b = a.get_child(a.get_child_count()-1)
						e=e+1
						spawn(b,false,1,false)

					6:
						a = corridor_left.instantiate()
						DoorContainer.get_child(i).add_child(a)
						b = a.get_child(a.get_child_count()-1)
						e=e+1
						spawn(b,false,1,false)
		else:
			for i in range(0,Door_Count):
				if(e<5):
					match(randi_range(1+f,4-d)):
						3:
							a = door2.instantiate()
							DoorContainer.get_child(i).add_child(a)
							b = a.get_child(a.get_child_count()-1)
							e=e+1
							spawn(b,true,1,false)
						1,2:
							a = end.instantiate()
							DoorContainer.get_child(i).add_child(a)
							b = a.get_child(a.get_child_count()-1)
						4:
							a = door4.instantiate()
							DoorContainer.get_child(i).add_child(a)
							b = a.get_child(a.get_child_count()-1)
							spawn(b,true,3,true)
							e=e+1
							d=1
							f=0
				else:
					a = end.instantiate()
					DoorContainer.get_child(i).add_child(a)
					b = a.get_child(a.get_child_count()-1)
	else:
		for i in range(0,Door_Count):
				a = corridor_strait.instantiate()
				DoorContainer.get_child(i).add_child(a)
				b = a.get_child(a.get_child_count()-1)
				e=e+1
				spawn(b,false,1,false)
