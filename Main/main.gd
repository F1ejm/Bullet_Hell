extends Node2D

#Random Eventy
@onready var random_events_timer: Timer = $Random_Events_Timer
@onready var cooldown_timer: Timer = $cooldown_timer

#który event ma sie odbyć
var x

#Eventy
var camera_shake: bool = false

var camera_fog: bool = false
@onready var mesh_instance_2d: MeshInstance2D = $CanvasLayer2/MeshInstance2D

func _ready() -> void:
	Timer_()

func _process(delta: float) -> void:
	print(Engine.time_scale,"NIGGER")
	if Global.IsRoundPlaying == false:
		Engine.time_scale = 1
	
	match(x):
		1:
			camera_shake = true
		2:
			camera_fog = true
			
	if camera_shake == true:
		Camera_Shake()
	
	if camera_fog == true:
		Camera_Fog()

#Funkcje uruchamiające
func Timer_():
	random_events_timer.wait_time = randi_range(15,25)
	random_events_timer.start()
	
func Choose_Event():
	x = randi_range(3,4)
	match(x):
		3:
			Engine.time_scale = 1.5
		4:
			Engine.time_scale = 0.5
	
#Funkcje Eventów
func Camera_Shake():
	if Global.IsRoundPlaying == true:
		pass #Nikita TODO

func Camera_Fog():
	if Global.IsRoundPlaying == true:
		pass

#Timery
func _on_random_events_timer_timeout() -> void:
	Choose_Event()
	Timer_()
	cooldown_timer.start()
	
func _on_cooldown_timer_timeout() -> void:
	camera_shake = false
	camera_fog = false
	Engine.time_scale = 1
	
