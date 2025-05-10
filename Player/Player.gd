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

var PowerUp_time: float = 5

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
var Projectiles_Trwanie: float = 5
var Projectiles_Cooldown: float = 10
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

#5 Burza piorunów
var Can_Use_Pioruny: bool = false
var Pioruny: bool
var Pioruny_Trwanie: float = 5
var Pioruny_Cooldown: float = 15
@onready var raycast_pioruny: RayCast2D = $Raycast_Pioruny
var pioruny_path = preload("res://Player/pioruny_aktywny_item.tscn")
var pioruny_burza

#Itemy Pasywne -------------------------------

# 1.5 raza szybsze pociski
var faster_bullets: bool = false

# 25% szans, że nie dostaniesz obrażeń
var immunity_chance: bool = false

# Piorun w losową strone
var Piorun: bool = false
var piorun_rand
@onready var pasywne_itemki: Node2D = $Pasywne_Itemki
@onready var piorun_area: Area2D = $Pasywne_Itemki/Piorun_Area

# Szlak za playerem
var Trace: bool = false
var trac_fire_path = preload("res://Player/player_fire_trace.tscn")

# Orbitale
var Orbitale: bool = false
@export var node_orbitali: Node2D

#Przebicie jednego przeciwnika przez bullety
var Bullet_Piercing_Pasywny: bool = false

#zycie które się regeneruje
var Regenerating_Health: bool = false
@onready var regenerating_timer: Timer = $Regenerating_Timer
var regenerating_wait_time: float = 19
var regen: bool = true

#Serce które się regeneruje
var Regenerating_Heart: bool = false
var Dodatkowe_Zycie: bool = false
@export var Zycie_UI: Control

#Pociski przelatują przez ścianę
var Ignore_wall_Item: bool = false

#------------------------------------------


#Zmienna Określająca czy collision shape do zabijania jest aktywny
var collision_atak: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować -- Ranged
var range_cooldown: bool = false
var bullet_path = preload("res://Player/player_bullet.tscn")
@onready var fire_trace_timer: Timer = $Fire_Trace_Timer

#variable do lockowwania rotacji przy dashu
var lock_rotation

#Zemienne do Broni  
var stats: WeaponStats = null
var CurrentSeriaNumber = 1
var is_sering = false

#Obrazenia
var dmg_melee: int = 1
var dmg_range: int = 1

#Audio

func _ready() -> void:
	atak_timer.wait_time = Global.AtakCooldown
	_on_weapon_changed()
	
	#fire trace - pasywny itemek
	fire_trace_timer.wait_time = 0.05
	
	#power up timer
	power_up_timer.wait_time = PowerUp_time
	
	#regenerujace zycie timer
	regenerating_timer.wait_time = regenerating_wait_time

func _process(delta: float) -> void:
	Global.player_main = $"."
	node_orbitali.global_position = global_position
	$Camera2D.global_position = (self.global_position * 3 +get_global_mouse_position())/4

func _physics_process(delta):
	
	if Global.stop == true:
		return
	#Power Up'y ----------------------------------------
	if Global.start_powerup_timer == true:
		Global.start_powerup_timer = false
		power_up_timer.start()
		
	#Pozytywne
	#1 Dash Zabija
	Dash_PowerUp = Global.Dash_PowerUp
	#2 Nieograniczona Stamina
	Stamina_PowerUp = Global.Stamina_PowerUp
	#3 Bullet Przecinający Inne Bullety
	Bullet_PowerUp = Global.Bullet_PowerUp
	#Negatywne
	#1 Nie możesz dashować przez 5 sekund
	Cant_Dash_PowerUp = Global.Cant_Dash_PowerUp
	#2 Nie możesz strzelać
	Cant_Shoot_PowerUp = Global.Cant_Shoot_PowerUp
	#3 Chodzisz 2 razy wolniej
	Move_Slower_PowerUp = Global.Move_Slower_PowerUp
		
	#Nie możesz dashować
	if Cant_Dash_PowerUp == true:
		Global.Stamina = 0
	
	#Chodzisz wolniej
	if Move_Slower_PowerUp == true:
		Global.speed = Global.debuffed_speed
	else:
		Global.speed = Global.normal_speed
		
	#Pasywne Itemki -------------------------------------
	node_orbitali.global_position = global_position
	if Orbitale == true:
		node_orbitali.Func_Orbitals(delta)
		
	#Pasywny Itemek - regenerujace sie zycie
	if Regenerating_Health == true and Global.Zycie < Global.Max_Zycie and regen == true and Global.IsRoundPlaying == true:
		regen = false
		regenerating_timer.start()
	
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
			trwanie_timer.wait_time = delta
			cooldown_timer.wait_time = AOE_Cooldown
		3:
			trwanie_timer.wait_time = delta
			cooldown_timer.wait_time = Clear_Cooldown
		4:
			trwanie_timer.wait_time = Pioruny_Trwanie
			cooldown_timer.wait_time = Pioruny_Cooldown
	
	#Tarcza
	if Input.is_action_just_pressed("active_item") and Can_Use_Tarcza == true:
		Tarcza = true
		Can_Use_Tarcza = false
		trwanie_timer.start()
	
	if Tarcza == true:
		Func_Tarcza()
	
	#AOE
	if Input.is_action_just_pressed("active_item") and Can_Use_AOE == true:
		AOE = true
		Can_Use_AOE = false
		trwanie_timer.start()
	
	if AOE == true:
		Func_AOE()
	
	#Clear
	if Input.is_action_just_pressed("active_item") and Can_Use_Clear == true:
		Clear = true
		Can_Use_Clear = false
		trwanie_timer.start()
	
	if Clear == true:
		Func_Clear()
		
	#Projectiles
	if Input.is_action_just_pressed("active_item") and Can_Use_Projectiles == true:
		Projectiles = true
		Can_Use_Projectiles = false
		trwanie_timer.start()
		
	
	if Projectiles == true:
		cooldown_timer.start()
		Func_Projectiles()
	
	#Pioruny
	if Input.is_action_just_pressed("active_item") and Can_Use_Pioruny == true:
		Pioruny = true
		Can_Use_Pioruny = false
		trwanie_timer.start()
		
		pioruny_burza = pioruny_path.instantiate()
		pioruny_burza.global_position = get_global_mouse_position()
		owner.add_child(pioruny_burza)
		
	if Pioruny == true:
		cooldown_timer.start()
	
		
	#Range Atak --------------------------------------------
	if Input.is_action_pressed("range_atak") and range_cooldown == false and Tarcza != true and Cant_Shoot_PowerUp != true:
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
		self.position = (self.position + velocity * value.x * delta * 0.08)

	if Input.is_action_just_pressed("dash") and Global.IsDashing == false and Global.Stamina > 0 and velocity != Vector2(0,0):
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


#Atak - Ranged
func Ranged():
	if(not stats.isShotgun):
		var b = bullet_path.instantiate()
		owner.add_child(b)
		b.transform = global_transform
		b.scale.x = 0.5
		b.scale.y = 0.5
		b.dmg = dmg_range
		b.PowerUp_Active = Bullet_PowerUp
		b.initial_velocity = velocity
			#Pasywny Itemek - faster_bullets
		if faster_bullets == true:
			b.speed = b.speed * 1.5
			
		#Pasywny Itemek - przebicie jednego przeciwnika
		if Bullet_Piercing_Pasywny == true:
			b.Pasywny_Item_Piercing = true
			
		#Pasywny itemek - przebicie ścian
		if Ignore_wall_Item == true:
			b.ignore_walls = true
		if(stats.isMinigun):
			b.rotation = self.rotation - randf_range(-3,3) * 0.1
	else:
		for i in range(0,4):
			var b = bullet_path.instantiate()
			owner.add_child(b)
			b.transform = global_transform
			b.scale.x = 0.5
			b.scale.y = 0.5
			b.dmg = dmg_range
			b.PowerUp_Active = Bullet_PowerUp
			b.initial_velocity = velocity
			b.rotation = self.rotation - (2-i*1.5)*0.1

			#Pasywny Itemek - faster_bullets
			if faster_bullets == true:
				b.speed = b.speed * 1.5

			#Pasywny Itemek - przebicie jednego przeciwnika
			if Bullet_Piercing_Pasywny == true:
				b.Pasywny_Item_Piercing = true
				
			#Pasywny itemek - przebicie ścian
			if Ignore_wall_Item == true:
				b.ignore_walls = true

	#Pasywny Itemek - Piorun
	pasywne_itemki.rotation = randi_range(0,360)
	if Piorun == true:
		piorun_rand = randi_range(1,4)
		if piorun_rand == 1:
			Func_Piorun()

	
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
	stats = load("res://Player/Weapons/%s_Stats.tres" % Global.CurrentWeapon)
	Global.RangeWeaponCooldown = stats.cooldown
	dmg_range = stats.dmg
	CurrentSeriaNumber = stats.seria
	
	
#Otrzymywanie Dmg'u
func Dmg_Func(x):
	if immunity_chance == true:
		var y = randi_range(1,4)
		if y == 1:
			#Animacja nie_dostania obrażeń - Pasywny itemek
			pass
		else:
			#Pasywny Item - regenerujace serduszko
			if Dodatkowe_Zycie == true:
				Dodatkowe_Zycie = false
			else:
				Global.Zycie -= x
				Global.immune = true
	else:
		#Pasywny Item - regenerujace serduszko
		if Dodatkowe_Zycie == true:
			Dodatkowe_Zycie = false
		else:
			Global.Zycie -= x
			Global.immune = true
	
		
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
		4:
			Pioruny = false
			pioruny_burza.queue_free()
	
	
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
		4:
			Can_Use_Pioruny = true

#Tarcza
func Func_Tarcza():
	for o in tarcza_item_area.get_overlapping_areas():
		if o.is_in_group("Bullet") or o.is_in_group("Boss_Bullet"):
			o.queue_free()

	
#AOE
func Func_AOE():
	for o in aoe_item_area.get_overlapping_areas():
		if o.is_in_group("Bullet") or o.is_in_group("Boss_Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.Death()
		if o.is_in_group("Boss") and o.can_be_hit == true:
			o.health -= 5
#Clear
func Func_Clear():
	for o in get_tree().get_nodes_in_group("Bullet"):
		o.queue_free()
	for o in get_tree().get_nodes_in_group("Boss_Bullet"):
		o.queue_free()

var b1_path = preload("res://Player/Naprowadzający_Bullet_Playera/naprowadzający_playera.tscn")

#Projectiles
func Func_Projectiles():
	Projectiles = false
	for o in projectiles_area.get_overlapping_areas():
		if o.is_in_group("Enemy") or o.is_in_group("Boss"):
			var b1 = b1_path.instantiate()
			b1.global_transform = global_transform
			b1.enemy = o
			b1.dmg = 3
			owner.add_child(b1)
		

#Piorun - Pasywny Itemek
func Func_Piorun():
	#Animacja Pioruna i SFX TODO
	for o in piorun_area.get_overlapping_areas():
		if o.is_in_group("Enemy"):
			o.owner.Death()
		if o.is_in_group("Boss") and o.can_be_hit == true:
			print("NIGGER")
			o.health -= 3

#Fire Trace - Pasywny Itemek
func _on_fire_trace_timer_timeout() -> void:
	if Trace == true and Global.IsDashing != true:
		var fire_trace = trac_fire_path.instantiate()
		fire_trace.global_transform = global_transform
		fire_trace.scale.x = 1
		fire_trace.scale.y = 1
		owner.add_child(fire_trace)

#Power Up Timer - wyłącza 
func _on_power_up_timer_timeout() -> void:
	#Pozytywne
	#1 Dash Zabija
	Global.Dash_PowerUp = false

	#2 Nieograniczona Stamina
	Global.Stamina_PowerUp = false

	#3 Bullet Przecinający Inne Bullety
	Global.Bullet_PowerUp = false

	#Negatywne
	#1 Nie możesz dashować przez 5 sekund
	Global.Cant_Dash_PowerUp = false
	
	#2 Nie możesz strzelać
	Global.Cant_Shoot_PowerUp = false

	#3 Chodzisz 2 razy wolniej
	Global.Move_Slower_PowerUp = false

#Pasywny Itemek timer - regenerujace sie zycie
func _on_regenerating_timer_timeout() -> void:
	if Global.IsRoundPlaying == true:
		regen = true
		Global.Zycie += 1
