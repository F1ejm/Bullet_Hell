extends Node2D

@onready var timer: Timer = $Spawnery/Timer
@export var Player: CharacterBody2D

@export var Podstawowy: PackedScene
@export var Seryjny: PackedScene
@export var Okrągły: PackedScene
@export var Naprowadzający: PackedScene

var Lista: Array = [Podstawowy,Seryjny,Okrągły,Naprowadzający]


#Rozmiar areny
var width = 1050
var height = 600

#koordynaty do spawnu
var x
var y

func _ready() -> void:
	Generate()

func _process(delta: float) -> void:
	if Global.i*Global.i - Global.Runda < 0:
		Generate()
	else:
		print( Global.i*Global.i - Global.Runda)
		timer.wait_time = Global.i*Global.i - Global.Runda


func _on_timer_timeout() -> void:
	Generate()
	
func Generate():
	Global.i += 1
	x = randi_range(0,width)
	y = randi_range(0,height)
	
	var losowanie_enemy = randi_range(0,len(Lista)-1)
	
	match(losowanie_enemy):
		0:
			var enemy = Podstawowy.instantiate()
			owner.add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,-y)
			enemy.Player = Player
		1:
			var enemy = Seryjny.instantiate()
			owner.add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,-y)
			enemy.Player = Player
		2:
			var enemy = Okrągły.instantiate()
			owner.add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,-y)
			enemy.Player = Player
		3:
			var enemy = Naprowadzający.instantiate()
			owner.add_child(enemy)
			enemy.main = owner
			enemy.global_position = Vector2(x,-y)
			enemy.Player = Player
	
