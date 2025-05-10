extends Node2D

@onready var timer: Timer = $Spawnery/Timer
@export var timer_power_up : Timer
@export var Player: CharacterBody2D

@export var Podstawowy: PackedScene
@export var Seryjny: PackedScene
@export var Okrągły: PackedScene
@export var Naprowadzający: PackedScene

@export var power_up : PackedScene

@export var czujka : PackedScene


@onready var ld : Marker2D = $ld
@onready var lg : Marker2D = $lg
@onready var pd : Marker2D = $pd
@onready var pg : Marker2D = $pg


var Lista: Array = [Podstawowy,Seryjny,Okrągły,Naprowadzający]


#Rozmiar areny
var width = 1050
var height = 1000

#koordynaty do spawnu
var x 
var y

#nwm jak to nazwać
var c


var marker_ld
var marker_lg
var marker_pd
var marker_pg 

func _ready() -> void:
	Global.i = -1
	Global.IsRoundPlaying = false
	global_rotation = 0
	c = Global.can_spawn
	timer_power_up.wait_time = randi_range(10,20)
	timer_power_up.start()
	rotation = rotation - global_rotation
	$NavigationRegion2D.rotation = $NavigationRegion2D.rotation - $NavigationRegion2D.global_rotation
	var markers = get_rotated_markers(rotation_degrees)

	
func get_rotated_markers(angle: int):
	var normalized_angle = abs(int(round(angle)) % 360)
	print(ld)
	match normalized_angle:
		0:
			marker_ld=ld
			marker_lg=lg
			marker_pd=pd
			marker_pg=pg
		90:
			marker_ld=lg
			marker_lg=pg
			marker_pd=ld
			marker_pg=pd
		180:
			marker_ld=pg
			marker_lg=pd
			marker_pd=lg
			marker_pg=ld
		270:
			marker_ld=pd
			marker_lg=ld
			marker_pd=pg
			marker_pg=lg

func _process(delta: float) -> void:
	global_rotation = 0
	if Global.can_spawn != c:
		c = Global.can_spawn
		Generate()
	
	if Global.IsRoundPlaying == true:
		if Global.i == 0:
			Generate()
		
		if Global.i*Global.i - Global.Runda < 0:
			Generate()
		elif Global.i*Global.i - Global.Runda > 0 and Global.i*Global.i - Global.Runda < 8:
			timer.wait_time = Global.i*Global.i - Global.Runda
		else:
			timer.wait_time = 8

func _on_timer_timeout() -> void:
	if Global.IsRoundPlaying == true:
		x = randi_range(int(ld.global_position.x)+30,int(pd.global_position.x)-30)
		y = randi_range(int(ld.global_position.y)+30,int(lg.global_position.y)-30)
		Generate()



func Generate():
	Global.i += 1
	
	x = randi_range(int(ld.global_position.x)+30,int(pd.global_position.x)-30)
	y = randi_range(int(ld.global_position.y)+30,int(lg.global_position.y)-30)
	
	var losowanie_enemy = randi_range(0,3)
	
	match(losowanie_enemy):
		0:
			var enemy = Podstawowy.instantiate()
			add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,y)
			enemy.Player = Player
		1:
			var enemy = Seryjny.instantiate()
			add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,y)
			enemy.Player = Player
		2:
			var enemy = Okrągły.instantiate()
			add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,y)
			enemy.Player = Player
		3:
			var enemy = Naprowadzający.instantiate()
			add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,y)
			enemy.Player = Player


func Generate_power_up():
	x = randi_range(20,width)
	y = randi_range(20,height)
	
	var enemy = power_up.instantiate()
	owner.add_child(enemy)
	enemy.global_position = Vector2(x,-y)




func _on_timer_power_up_timeout() -> void:
	if Global.IsRoundPlaying:
		timer_power_up.wait_time = randi_range(10,20)
		Generate_power_up()
