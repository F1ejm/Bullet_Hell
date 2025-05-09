extends Node2D

@onready var timer: Timer = $Spawnery/Timer
@export var timer_power_up : Timer
var Player: CharacterBody2D

@export var Podstawowy: PackedScene
@export var Seryjny: PackedScene
@export var Okrągły: PackedScene
@export var Naprowadzający: PackedScene

@export var power_up : PackedScene

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
	Player = Global.player_main
	c = Global.can_spawn
	timer_power_up.wait_time = randi_range(10,20)
	timer_power_up.start()
	

func _process(delta: float) -> void:
	Player = Global.player_main
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
		Generate()

func Generate():
	Player = Global.player_main
	Global.i += 1
	x = randi_range(20,width)
	y = randi_range(20,height)
	
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
