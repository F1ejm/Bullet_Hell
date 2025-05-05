extends CharacterBody2D

@onready var ui: Control = $CanvasLayer/UI
@onready var node_2d: Node2D = $Node2D
@onready var melee_attack_area: Area2D = $Node2D/Melee_attack_area
@onready var timer: Timer = $Collision_Timer
@onready var atak_timer: Timer = $Atak_Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var range_timer: Timer = $Range_Timer
@onready var parry_area: Area2D = $"Node2D/Parry area"

@onready var sprite_2d: Sprite2D = $Node2D/Melee_attack_area/Sprite2D

#Power Up'y --------------------------------

@onready var power_up_timer: Timer = $PowerUp_Timer

var PowerUp_Active: bool = false
var PowerUp_time: float = 10

#1 Tarcza Z Jednej Strony
var Tarcza_PowerUp: bool = false

#2 Dash Zabija
var Dash_PowerUp: bool = false

#3 Nieograniczona Stamina
var Stamina_PowerUp: bool = false

#4 Bullet Przecinający Inne Bullety
var Bullet_PowerUp: bool = false


#Itemy Aktywne --------------------------------

var Current_Active_Item: int = 1
@onready var trwanie_timer: Timer = $Trwanie_Timer
@onready var cooldown_timer: Timer = $Cooldown_Timer

#1 Tarcza w Okół Gracza
var Can_Use_Tarcza: bool = false
var Tarcza: bool
var Tarcza_Trwanie: float = 5
var Tarcza_Cooldown: float = 15
@onready var tarcza_item_area: Area2D = $Tarcza_Item_Area

#2 Pociski namierzające
var Can_Use_Projectiles: bool = true
var Projectiles: bool
var Projectiles_Trwanie: float = 0
var Projectiles_Cooldown: float = 5
@onready var projectiles_area: Area2D = $Projectiles_Area

#3 AOE w Okół Gracza
var Can_Use_AOE: bool = false
var AOE: bool
var AOE_Trwanie: float = 1
var AOE_Cooldown: float = 15
@onready var aoe_item_area: Area2D = $AOE_Item_Area

#4 Usuwanie Bulletów na całej mapie
var Can_Use_Clear: bool = false
var Clear: bool
var Clear_Trwanie: float = 1
var Clear_Cooldown: float = 20


#Itemy Pasywne -------------------------------


#------------------------------------------


#Zmienna Określająca czy collision shape do zabijania jest aktywny
var collision_atak: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować -- Melee
var atak_cooldown: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować -- Ranged
var range_cooldown: bool = false
var bullet_path = preload("res://Player/player_bullet.tscn")

#variable do lockowwania rotacji przy dashu
var lock_rotation

#Zemienne do Broni
var stats: WeaponStats = null
var CurrentWeapon = "Pistol"
var CurrentSeriaNumber = 1
var is_sering = false

#Obrazenia
var dmg_melee: int = 1
var dmg_range: int = 1

#Audio
@onready var atak_mele: AudioStreamPlayer = $Sound/AtakMele
@onready var blok_1: AudioStreamPlayer = $Sound/Blok1
@onready var blok_2: AudioStreamPlayer = $Sound/Blok2
@onready var blok_3: AudioStreamPlayer = $Sound/Blok3


func _ready() -> void:
	atak_timer.wait_time = Global.AtakCooldown
	_on_weapon_changed()
	

func _physics_process(delta):
	if Global.stop == true:
		return
	#Itemy Aktywne -----------------------------------------
	
	#Timery
	match(Current_Active_Item):
		0:
			trwanie_timer.wait_time = Tarcza_Trwanie
			cooldown_timer.wait_time = Tarcza_Cooldown
		1:
			trwanie_timer.wait_time = Projectiles_Trwanie
			cooldown_timer.wait_time = Projectiles_Cooldown
		2:
			trwanie_timer.wait_time = AOE_Trwanie
			cooldown_timer.wait_time = AOE_Cooldown
		3:
			trwanie_timer.wait_time = Clear_Trwanie
			cooldown_timer.wait_time = Clear_Cooldown
	
	#Tarcza
	if Input.is_action_just_pressed("active_item") and Current_Active_Item == 0 and Can_Use_Tarcza == true:
		Tarcza = true
		Can_Use_Tarcza = false
		trwanie_timer.start()
	
	if Tarcza == true:
		Func_Tarcza()
	
	#AOE
	if Input.is_action_just_pressed("active_item") and Current_Active_Item == 2 and Can_Use_AOE == true:
		AOE = true
		Can_Use_AOE = false
		trwanie_timer.start()
	
	if AOE == true:
		Func_AOE()
	
	#Clear
	if Input.is_action_just_pressed("active_item") and Current_Active_Item == 3 and Can_Use_Clear == true:
		Clear = true
		Can_Use_Clear = false
		trwanie_timer.start()
	
	if Clear == true:
		Func_Clear()
		
	#Projectiles
	if Input.is_action_just_pressed("active_item") and Current_Active_Item == 1 and Can_Use_Projectiles == true:
		Projectiles = true
		Can_Use_Projectiles = false
		trwanie_timer.start()
	
	if Projectiles == true:
		cooldown_timer.start()
		Func_Projectiles()
	
	#Atak - Melee ------------------------------------------------
	atak_timer.wait_time = Global.AtakCooldown
	
	
	
	if Input.is_action_just_pressed("atak") and atak_cooldown == false and Tarcza != true:
		atak_timer.stop()
		atak_timer.start()
		timer.stop()
		timer.start()
		collision_atak = true
		atak_cooldown = true
		
	if collision_atak == true:
		sprite_2d.visible = true #Zamiast Tego Animacja TODO
		parry_area.monitoring = true
		Atak()
		
	#Range Atak --------------------------------------------
	if Input.is_action_pressed("range_atak") and range_cooldown == false and Tarcza != true:
		if not is_sering:
			CurrentSeriaNumber=1
			if(stats.seria>1):
				range_timer.wait_time = (Global.RangeCooldown * Global.RangeWeaponCooldown) / 20
				
			else:
				range_timer.wait_time = Global.RangeCooldown * Global.RangeWeaponCooldown
			range_timer.stop()
			range_timer.start()
			range_cooldown = true
			Ranged()
	
	#Dash
	if Global.IsDashing:
		rotation = lock_rotation
		var current_time = animation_player.current_animation_position
		var value = animation_player.get_animation("dash").value_track_interpolate(1,current_time)
		self.position = (self.position + velocity * value.x * delta * 0.04)

	if Input.is_action_just_pressed("dash") and Global.IsDashing == false and Global.Stamina > 0:
		if Stamina_PowerUp == true:
			animation_player.play("dash")
		else:
			animation_player.play("dash")
			Global.Stamina -= Global.Koszt_Dasha
		
		
	#Ruch
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * Global.speed

	move_and_slide()

#Atak - melee
func Atak():
	#Zabijanie Przeciwnika
	for o in melee_attack_area.get_overlapping_areas():
		if o.is_in_group("Enemy"):
			atak_mele.pitch_scale = randf_range(0.9, 1.05)
			atak_mele.play()
			#Animacja I SFX Obrazen przeciwnika TODO
			o.owner.health -= dmg_melee
#Atak - melee
func _on_timer_timeout() -> void:
	sprite_2d.visible = false #Zamiast Tego Animacja TODO
	parry_area.monitoring = false
	collision_atak = false
func _on_atak_timer_timeout() -> void:
	atak_cooldown = false

#Atak - Ranged
func Ranged():
	var b = bullet_path.instantiate()
	owner.add_child(b)
	b.transform = global_transform
	b.scale.x = 0.5
	b.scale.y = 0.5
	b.dmg = dmg_range
	b.PowerUp_Active = Bullet_PowerUp
	b.initial_velocity = velocity
		

#Atak - Ranged
func _on_range_timer_timeout() -> void:
	range_cooldown = false
	if stats.seria>1 and CurrentSeriaNumber < stats.seria:
		is_sering=true
		Ranged()
		CurrentSeriaNumber=CurrentSeriaNumber+1
	elif stats.seria>1:
		range_timer.wait_time = Global.RangeCooldown * Global.RangeWeaponCooldown
		if is_sering:
			is_sering=false
			range_cooldown = true
			range_timer.stop()
			range_timer.start()
			


#Dash
func _startdash():
	Global.IsDashing = true
	lock_rotation = rotation
func _stopdash():
	Global.IsDashing = false

#Odświerza Broń !Trzeba Najpierw Zmienić Nazwe!
func _on_weapon_changed() -> void:
	stats = load("res://Player/Weapons/%s_Stats.tres" % CurrentWeapon)
	Global.RangeWeaponCooldown = stats.cooldown
	dmg_range = stats.dmg

#Parry
func _on_parry_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		var x = randi_range(0,2)
		match(x):
			0:
				blok_1.play()
			1:
				blok_2.play()
			2:
				blok_3.play()
		area.queue_free()
		
#Itemy Aktywne ------------------------------------------
func _on_trwanie_timer_timeout() -> void:
	cooldown_timer.start()
	trwanie_timer.stop()
	match(Current_Active_Item):
		0:
			Tarcza = false
		1:
			Projectiles = false
		2:
			AOE = false
		3:
			Clear = false
	
	
func _on_cooldown_timer_timeout() -> void:
	match(Current_Active_Item):
		0:
			Can_Use_Tarcza = true
		1:
			Can_Use_Projectiles = true
		2:
			Can_Use_AOE = true
		3:
			Can_Use_Clear = true

#Tarcza
func Func_Tarcza():
	for o in tarcza_item_area.get_overlapping_areas():
		if o.is_in_group("Bullet"):
			o.queue_free()

	
#AOE
func Func_AOE():
	for o in aoe_item_area.get_overlapping_areas():
		if o.is_in_group("Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.Death()
			
#Clear
func Func_Clear():
	for o in get_tree().get_nodes_in_group("Bullet"):
		o.queue_free()

var b1_path = preload("res://Player/Naprowadzający_Bullet_Playera/naprowadzający_playera.tscn")

#Projectiles
func Func_Projectiles():
	Projectiles = false
	for o in projectiles_area.get_overlapping_areas():
		if o.is_in_group("Enemy"):
			var b1 = b1_path.instantiate()
			b1.global_transform = global_transform
			b1.global_position.y += 40
			b1.enemy = o
			b1.dmg = 3
			owner.add_child(b1)
