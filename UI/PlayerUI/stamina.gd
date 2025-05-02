extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $Timer

var dash:bool = false

func _ready() -> void:
	progress_bar.size.x = Global.Max_Stamina
	progress_bar.max_value = Global.Max_Stamina
	
func _physics_process(delta: float) -> void:
	
	progress_bar.size.x = Global.Max_Stamina
	progress_bar.max_value = Global.Max_Stamina
	progress_bar.value = Global.Stamina
	
	#Regeneracja Staminy
	if Global.Stamina < Global.Max_Stamina and dash == false:
		Global.Stamina += Global.Stamina_Regen * 80 * delta

	#Sprawdzenie Czy jest Dash
	if dash == true:
		timer.start()

func _on_timer_timeout() -> void:
	dash = false
