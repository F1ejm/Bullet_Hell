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

#Attack Speed Gracza - melee
var AtakCooldown: float = 0.4
#Attack Speed Gracza - range
var RangeCooldown: float = 2

var RangeWeaponCooldown: float = 1

#Pieniądze
var VDolce: int = 0

#Immunity Gracza Po Otrzymaniu obrażeń
var immune: bool = false
var immunity: float = 1

#Immunity Przy dashu
var dash_immunity: bool = false
var dash_imm_timer: float = 0

#Rundy
var Runda: int = 0
var IsRoundPlaying: bool
var Czas_Rundy: float = 60
var Generate_wall: bool = false

#Liczba Przeciwników
var i: int = -1

#czujka czy przeciwnik możę sie pojawić
var can_spawn : int = 0

#Timer Do Staminy
var timer: float = 0
func _process(delta: float) -> void:
	if Zycie > Max_Zycie:
		Zycie = Max_Zycie
	
	#System Rund
	if Input.is_action_just_pressed("next_round_button") and IsRoundPlaying != true:
		IsRoundPlaying = true
		Czas_Rundy = 60
		Runda += 1
	if IsRoundPlaying == true:
		Czas_Rundy -= delta
	if Czas_Rundy <= 0:
		IsRoundPlaying = false
		
	if IsRoundPlaying == false:
		for o in get_tree().get_nodes_in_group("Bullet"):
			o.queue_free()
		for o in get_tree().get_nodes_in_group("Enemy"):
			o.queue_free()
	#Timer Do Staminy - Jeśli wyjdziesz staminą na minus to tedy to sie aktywuje
	if Stamina < 0:
		Long_Stamina_cdr = true
		Stamina = 0
	if Long_Stamina_cdr == true:
		timer += delta
	if timer >= 2:
		Long_Stamina_cdr = false
		timer = 0
		
	#Immunity Gracza 
	if immune == true:
		immunity -= delta
	if immunity <= 0:
		immune = false
		immunity = 1
	
	if IsDashing == true:
		dash_immunity = true
		dash_imm_timer = 0.4
	if dash_immunity == true:
		dash_imm_timer -= delta
	if dash_imm_timer <= 0:
		dash_immunity = false
