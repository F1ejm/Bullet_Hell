extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	progress_bar.size.x = Global.Max_Stamina
	progress_bar.max_value = Global.Max_Stamina
	
func _process(delta: float) -> void:
	print(Global.Stamina)
	progress_bar.size.x = Global.Max_Stamina
	progress_bar.max_value = Global.Max_Stamina
	progress_bar.value = Global.Stamina
	
	#Regeneracja Staminy
	if Global.Stamina < Global.Max_Stamina:
		Global.Stamina += Global.Stamina_Regen * 80 * delta
	
	#Upewnienie Się Ze nie wychodzi poza limit
	if Global.Stamina > Global.Max_Stamina:
		Global.Stamina = Global.Max_Stamina
