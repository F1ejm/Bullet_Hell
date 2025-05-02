extends Node

#Player Speed
var speed: int = 600
var stop: bool = false

#Interaction
var show_interaction: bool = false

#Shop
var shop_can_interact: bool = false
var shop_ui_visible: bool = false

#Życie
var Zycie: int = 3
var Max_Zycie: int = 3

#Stamina
var Stamina: float = 200
var Max_Stamina: float = 200
var Stamina_Regen: float = 1
var Dash: bool = false
#Stamina - jeśli wejdziesz na minus ze stamina to sie aktywuje
var Long_Stamina_cdr: bool = false

#Dash
var IsDashing: bool
var dash_timer: float = 0
var Koszt_Dasha: int = 60

#Rundy
var Runda: int = 0
var Czas_Rundy: float = 0
var Generate_wall: bool = false

#Timer Do Staminy
var timer: float = 0
func _process(delta: float) -> void:
	if Stamina < 0:
		Long_Stamina_cdr = true
		Stamina = 0
	if Long_Stamina_cdr == true:
		timer += delta
	if timer >= 1.5:
		Long_Stamina_cdr = false
		timer = 0
