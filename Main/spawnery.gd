extends Node2D

@onready var timer: Timer = $Spawnery/Timer
@export var Player: CharacterBody2D

@export var Podstawowy: PackedScene
@export var Seryjny: PackedScene
@export var Okrągły: PackedScene
@export var Naprowadzający: PackedScene

@export var czujka : PackedScene

var Lista: Array = [Podstawowy,Seryjny,Okrągły,Naprowadzający]


#Rozmiar areny
var width = 1050
var height = 600

#koordynaty do spawnu
var x
var y

#nwm jak to nazwać
var c

func _ready() -> void:
	c = Global.can_spawn
	

func _process(delta: float) -> void:
	if Global.can_spawn != c:
		c = Global.can_spawn
		print("chuj ci w ucho")
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
		Generate()
	
func Generate():
	Global.i += 1
	x = randi_range(20,width)
	y = randi_range(20,height)
	
	#jakieś coś napisane przez kube - To Poprostu losuje jakiego przeciwnika zespawnic cwelu ~ Kuba
	var losowanie_enemy = randi_range(0,3)
	
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
	
