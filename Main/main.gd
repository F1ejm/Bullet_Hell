extends Node2D

#Random Eventy
@onready var random_events_timer: Timer = $random_event_timer
@onready var label: Label = $CanvasLayer/Unstable_label
@onready var unstable_label_2: Label = $CanvasLayer/Unstable_label2

@export var Player:CharacterBody2D

var time: float = 0

#który event ma sie odbyć
var x

#Eventy
@onready var shader_material :ShaderMaterial = $CanvasLayer2/MeshInstance2D.material

var zycie_restored: int = 0

func _ready() -> void:
	label.visible = false
	unstable_label_2.visible = false
	Timer_()

func _process(delta: float) -> void:
	#AudioManager.
	if Global.IsRoundPlaying == false and get_tree().get_nodes_in_group("Boss").size() == 0:
		Global.Zycie += zycie_restored
		Global.Unstable_World = true
		zycie_restored = 0
		shader_material.set_shader_parameter("vignette_power", 12.0)
		shader_material.set_shader_parameter("vignette_divisor", 10.0)
		Engine.time_scale = 1
		label.visible = false 
		unstable_label_2.visible = false
	
	if label.visible == true:
		time += delta
	if time >= 3.5:
		time = 0
		label.visible = false
		unstable_label_2.visible = false
	

#Funkcje uruchamiające
func Timer_():
	random_events_timer.wait_time = randi_range(10,15)
	random_events_timer.start()
	
func Choose_Event():
	#Tu jakieś SFX i wizualnie rzeczy TODO
	if Global.IsRoundPlaying == true or get_tree().get_nodes_in_group("Boss").size() == 1:
		Global.Zycie += zycie_restored
		Global.Unstable_World = true
		zycie_restored = 0
		shader_material.set_shader_parameter("vignette_power", 12.0)
		shader_material.set_shader_parameter("vignette_divisor", 10.0)
		Engine.time_scale = 1
		
		label.visible = true
		
		
		x = randi_range(1,5)
		
		match(x):
			1:
				Camera_Shake()
				unstable_label_2.text = "The System Erupts"
			2:
				shader_material.set_shader_parameter("vignette_power", 4.0)
				shader_material.set_shader_parameter("vignette_divisor", 1.0)
				unstable_label_2.text = "The System Covers Itself With Immense Fog"
			3:
				Engine.time_scale = 1.3
				unstable_label_2.text = "The System Magically Speeds Up"
			4:
				Engine.time_scale = 0.7
				unstable_label_2.text = "The System Magically Slows Down"
			5:
				Health_Taken()
				unstable_label_2.text = "The System Temporarily Sucks Your Health Out Of You"
		
		unstable_label_2.visible = true
	
func _on_random_event_timer_timeout() -> void:
	
	Choose_Event()
	Timer_()
	
#Funkcje Eventów
func Camera_Shake():
	Player.Camera_Shake(40, 5)
	print("NIGGA")
		
func Health_Taken():
	zycie_restored = Global.Zycie - 2
	Global.Zycie = 2
	
		
