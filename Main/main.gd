extends Node2D

#Random Eventy
@onready var random_events_timer: Timer = $random_event_timer
@onready var label: Label = $CanvasLayer/Label

var time: float = 0

#który event ma sie odbyć
var x

#Eventy
@onready var shader_material :ShaderMaterial = $CanvasLayer2/MeshInstance2D.material

var zycie_restored: int = 0

func _ready() -> void:
	Timer_()

func _process(delta: float) -> void:
	if label.visible == true:
		time += delta
	if time >= 2:
		time = 0
		label.visible = false
	

#Funkcje uruchamiające
func Timer_():
	random_events_timer.wait_time = randi_range(10,15)
	random_events_timer.start()
	
func Choose_Event():
	#Tu jakieś SFX i wizualnie rzeczy TODO
	Global.Zycie += zycie_restored
	zycie_restored = 0
	shader_material.set_shader_parameter("vignette_power", 12.0)
	shader_material.set_shader_parameter("vignette_divisor", 10.0)
	Engine.time_scale = 1
	
	label.visible = true
	
	x = randi_range(1,5)
	match(x):
		1:
			Camera_Shake()
		2:
			shader_material.set_shader_parameter("vignette_power", 2.0)
			shader_material.set_shader_parameter("vignette_divisor", 1.0)
		3:
			Engine.time_scale = 1.3
		4:
			Engine.time_scale = 0.7
		5:
			#SFX i Wizualnie tu Trzeba TODO
			Health_Taken()
	
func _on_random_event_timer_timeout() -> void:
	Choose_Event()
	Timer_()

	
#Funkcje Eventów
func Camera_Shake():
	if Global.IsRoundPlaying == true:
		pass #Nikita TODO

		
func Health_Taken():
	zycie_restored = Global.Zycie - 1
	Global.Zycie = 1
