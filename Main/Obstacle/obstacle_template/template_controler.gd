extends Node2D

@export var timer : Timer 
@export var midle : Marker2D

@export var template_1 : PackedScene
@export var template_2 : PackedScene
@export var template_3 : PackedScene

@export var Placeholder : Node2D

var runda_play : bool
var runda_num : int
var runda_time : float

var lista : Array = []
var random : int 

func _ready() -> void:
	runda_num = 0
	runda_play = Global.IsRoundPlaying
	runda_time = Global.Czas_Rundy
	generate()

func generate():
	random = randi_range(0,2)
	print(random)
	match random : 
		0: 
			var b = template_1.instantiate()
			Placeholder.add_child(b)
			b.global_position = midle.global_position
			
		1: 
			var b = template_2.instantiate()
			Placeholder.add_child(b)
			b.global_position = midle.global_position
		2: 
			var b = template_3.instantiate()
			Placeholder.add_child(b)
			b.global_position = midle.global_position



func start_rundy():
	if Global.Runda != runda_num:
		runda_num = Global.Runda
		if Global.IsRoundPlaying != runda_play:
			runda_play = Global.IsRoundPlaying
			timer.start()



func _process(delta: float) -> void:
	start_rundy()

func timeout() -> void:
	Placeholder.get_child(0).queue_free()
	generate()
	timer.start()
	
