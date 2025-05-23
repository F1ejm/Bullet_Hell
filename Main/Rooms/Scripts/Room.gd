extends Node2D


var corridor_strait = preload("res://Main/Rooms/Halls/Hall_Strait.tscn")
var corridor_right = preload("res://Main/Rooms/Halls/Hall_Corner_Right.tscn")
var corridor_left = preload("res://Main/Rooms/Halls/Hall_Corner_Left.tscn")
var door2 = preload("res://Main/Rooms/Normal_Rooms/2dor.tscn")
var door4 = preload("res://Main/Rooms/Normal_Rooms/4dor.tscn")
var boss = preload("res://Main/Rooms/Boss_Room.tscn")
var end = preload("res://Main/Rooms/Normal_Rooms/End.tscn")
var shop = preload("res://Main/Rooms/Normal_Rooms/Shop.tscn")
var a 
var LastDoorContainer
var d = 0
var room_limit = 0
var left = 0
var right = 0

var shoopkeeper_ui

func _ready():
	LastDoorContainer = self
	spawn(LastDoorContainer,true,1,false)
	$"..".rotation= (randi_range(1,4)/2) * PI
	shoopkeeper_ui = get_node("/root/Main/CanvasLayer/shopkeeper_ui")
	print("a")
	
func _reset() -> void:
	AudioManager.zmiana_mapy.play()
	self.get_child(0).get_child(0).queue_free()
	LastDoorContainer = self
	d = 0
	room_limit = 0
	left = 0
	right = 0
	Global.Runda += 1
	spawn(LastDoorContainer,true,1,false)
	shoopkeeper_ui.Zmiana_Sklepu()
	
func spawn(DoorContainer,isRoom,Door_Count,is4door) -> void:
	if(not is4door):
		if(isRoom):
			for i in range(0,Door_Count):
				match(randi_range(1+right,5-left)):
					2,3,4:
						a = corridor_strait.instantiate()
						DoorContainer.get_child(i).add_child(a)
						LastDoorContainer = a.get_child(a.get_child_count()-1)
						spawn(LastDoorContainer,false,1,false)
						

					1:
						a = corridor_right.instantiate()
						DoorContainer.get_child(i).add_child(a)
						LastDoorContainer = a.get_child(a.get_child_count()-1)
						spawn(LastDoorContainer,false,1,false)
						right=1

					5:
						a = corridor_left.instantiate()
						DoorContainer.get_child(i).add_child(a)
						LastDoorContainer = a.get_child(a.get_child_count()-1)
						spawn(LastDoorContainer,false,1,false)
						left=1
		else:
			for i in range(0,Door_Count):
				if(room_limit<3):
					print(room_limit)
					match(randi_range(1+d,1+d)):
						2:
							a = door2.instantiate()
							DoorContainer.get_child(i).add_child(a)
							LastDoorContainer = a.get_child(a.get_child_count()-1)
							room_limit=room_limit+1
							spawn(LastDoorContainer,true,1,false)

						1:
							a = door4.instantiate()
							DoorContainer.get_child(i).add_child(a)
							LastDoorContainer = a.get_child(a.get_child_count()-1)
							room_limit=room_limit+1
							d=d+1
							spawn(LastDoorContainer,true,3,true)
				elif(room_limit==3):
					a = boss.instantiate()
					DoorContainer.get_child(i).add_child(a)
					LastDoorContainer = a.get_child(a.get_child_count()-1)
					room_limit=room_limit+1
				elif(room_limit==4):
					a = shop.instantiate()
					DoorContainer.get_child(i).add_child(a)
					LastDoorContainer = a.get_child(a.get_child_count()-1)
					room_limit=room_limit+1
				else:
					a = end.instantiate()
					DoorContainer.get_child(i).add_child(a)
					LastDoorContainer = a.get_child(a.get_child_count()-1)
	else:
		for i in range(0,Door_Count):
				a = corridor_strait.instantiate()
				DoorContainer.get_child(i).add_child(a)
				LastDoorContainer = a.get_child(a.get_child_count()-1)
				spawn(LastDoorContainer,false,1,false)
