extends Node
#Tutorial
var skip_tutorial: bool = false

var Start_Tutorial: bool = true

var Pierwszy_Pokój: bool = false
var Show_Pierwszy_Pokój: bool = true

var Unstable_World: bool = false
var Show_Unstable_World: bool = true

var Shop1: bool = false
var Show_Shop1: bool = true

var Shopkeeper: bool = false
var Show_Shopkeeper: bool = true

func skip_tutorial_func():
	if skip_tutorial == true:
		Show_Pierwszy_Pokój = false
		Show_Shop1 = false
		Show_Unstable_World = false
		Show_Shopkeeper = false
	else:
		Show_Pierwszy_Pokój = true
		Show_Shop1 = true
		Show_Unstable_World = true
		Show_Shopkeeper = true

#Logo
var play_intro := true
#Player Powerups
var start_powerup_timer: bool = false
#Pozytywne
#1 Dash Zabija
var Dash_PowerUp: bool = false
#2 Nieograniczona Stamina
var Stamina_PowerUp: bool = false
#3 Bullet Przecinający Inne Bullety
var Bullet_PowerUp: bool = false
#Negatywne
#1 Nie możesz dashować przez 5 sekund
var Cant_Dash_PowerUp: bool = false
#2 Nie możesz strzelać
var Cant_Shoot_PowerUp: bool = false

#3 Chodzisz 2 razy wolniej
var Move_Slower_PowerUp: bool = false
#Player Speed
var speed: int = 600
var normal_speed: int = speed
var debuffed_speed: int = speed * 0.5
var stop: bool = false

#Interaction
var show_interaction: bool = false

var label_boss: bool = false

#Shop
var shop_can_interact: bool = false
var shop_ui_visible: bool = false

var show_shopkeeper: bool = false
var shopkeeper_ui_visible: bool = false

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

#Karabin, Pistol, Uzi
var CurrentWeapon = "Pistol" 
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
var Runda: int = 1
var IsRoundPlaying: bool
var Czas_Rundy: float = 60
var Generate_wall: bool = false

#Settings
var current_resolution: Vector2i
var current_resolution_id: int
var current_fullscreen_mode: int # 1-windowed, 2-fullscreen, 3-borderless

var current_master_volume: float = 100
var current_music_volume: float = 100
var current_sfx_volume: float = 100

var is_in_settings := false # dotyczy settingsów w pause menu
var is_in_game := false
var is_in_pause_menu := false


#Liczba Przeciwników
var i: int = -1

#czujka czy przeciwnik możę sie pojawić
var can_spawn : int = 0

#Timer Do Staminy
var timer: float = 0

#nwm co to ale potrzebne
var player_main
func _ready() -> void:
	#skip_tutorial_func()
	Start_Tutorial = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func reset():
	#Tutorial
	Start_Tutorial = true

	Pierwszy_Pokój = false

	Unstable_World = false

	Shop1 = false

	Shopkeeper = false
	
	# Logo
	play_intro = false

	# Power-up start
	start_powerup_timer = false

	# Power-upy pozytywne
	Dash_PowerUp = false
	Stamina_PowerUp = false
	Bullet_PowerUp = false

	# Power-upy negatywne
	Cant_Dash_PowerUp = false
	Cant_Shoot_PowerUp = false
	Move_Slower_PowerUp = false

	# Player speed
	speed = 600
	normal_speed = 600
	debuffed_speed = 600 * 0.5
	stop = false

	# Interakcje
	show_interaction = false
	label_boss = false

	# Sklep
	shop_can_interact = false
	shop_ui_visible = false
	show_shopkeeper = false
	shopkeeper_ui_visible = false

	# Życie
	Zycie = 3
	Max_Zycie = 3

	# Stamina
	Stamina = 200.0
	Max_Stamina = 200.0
	Stamina_Regen = 1.0
	Dash = false
	Long_Stamina_cdr = false

	# Dash
	IsDashing = false
	dash_timer = 0.0
	Koszt_Dasha = 60

	# Atak
	AtakCooldown = 0.4
	RangeCooldown = 2.0
	CurrentWeapon = "Pistol"
	RangeWeaponCooldown = 1.0

	# Kasa
	VDolce = 0

	# Immunity
	immune = false
	immunity = 1.0

	# Dash Immunity
	dash_immunity = false
	dash_imm_timer = 0.0

	# Runda
	Runda = 0
	IsRoundPlaying = false
	Czas_Rundy = 60.0
	Generate_wall = false

	is_in_settings = false
	is_in_game = false
	is_in_pause_menu = false

	# Przeciwnicy
	i = -1
	can_spawn = 0

	# Timer staminy
	timer = 0.0

func _process(delta: float) -> void:
	#Pauzowanie Gry
	if is_in_game == false:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
	#Kursor
	if is_in_game == false or stop == true:
		Input.set_custom_mouse_cursor(load("res://Art/cursor/cursor.png"))
	else:
		Input.set_custom_mouse_cursor(load("res://Art/cursor/pixil-frame-0 (28).png"))
	
	if Zycie > Max_Zycie:
		Zycie = Max_Zycie
	
	#System Rund
	if IsRoundPlaying == true and is_in_game != false:
		Czas_Rundy -= delta
	if Czas_Rundy <= 0:
		IsRoundPlaying = false
		
	if IsRoundPlaying == false:
		for o in get_tree().get_nodes_in_group("Bullet"):
			o.queue_free()
		for o in get_tree().get_nodes_in_group("Enemy"):
			o.queue_free()
		for o in get_tree().get_nodes_in_group("Pick_Up_Objects"):
			o.queue_free()
		Zycie = Max_Zycie
		i = -1
		Global.Czas_Rundy = 60
	#Timer Do Staminy - Jeśli wyjdziesz staminą na minus to tedy to sie aktywuje
	if Stamina < 0:
		Long_Stamina_cdr = true
		Stamina = 0
	if Long_Stamina_cdr == true:
		timer += delta
	if timer >= 1:
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
