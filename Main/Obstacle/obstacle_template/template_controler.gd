extends Node2D

@export var timer : Timer 
@export var midle : Marker2D

@export var template_1 : PackedScene
@export var template_2 : PackedScene
@export var template_3 : PackedScene


var runda_play : bool
var runda_num : int
var runda_time : float

var lista : Array = []
var random : int 

func _ready() -> void:
	runda_num = 0
	runda_play = Global.IsRoundPlaying
	runda_time = Global.Czas_Rundy

func generate():
	random = randi_range(0,2)
	print(random)
	match random : 
		0: 
			var b = template_1.instantiate()
			add_child(b)
			b.transform = midle.transform
			
		1: 
			var b = template_2.instantiate()
			add_child(b)
			b.transform = midle.transform
		2: 
			var b = template_2.instantiate()
			add_child(b)
			b.transform = midle.transform



func start_rundy():
	if Global.Runda != runda_num:
		runda_num = Global.Runda
		if Global.IsRoundPlaying != runda_play:
			runda_play = Global.IsRoundPlaying
			timer.start()



func _process(delta: float) -> void:
	start_rundy()

func timeout() -> void:
	generate()
	timer.start()
	
