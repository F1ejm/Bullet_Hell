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

#Zmienna Określająca czy collision shape do zabijania jest aktywny
var collision_atak: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować -- Melee
var atak_cooldown: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować -- Ranged
var range_cooldown: bool = false
var bullet_path = preload("res://Player/player_bullet.tscn")

#variable do lockowwania rotacji przy dashu
var lock_rotation

#Obrazenia
var dmg_melee: int = 1
var dmg_range: int = 1

func _ready() -> void:
	atak_timer.wait_time = Global.AtakCooldown

func _physics_process(delta):
	if Global.stop == true:
		return
		
	#Atak - Melee
	atak_timer.wait_time = Global.AtakCooldown
	
	if Input.is_action_just_pressed("atak") and atak_cooldown == false:
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
		
	#Atak - Ranged
	range_timer.wait_time = Global.RangeCooldown
	
	if Input.is_action_just_pressed("range_atak") and range_cooldown == false:
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
		Global.Stamina -= Global.Koszt_Dasha
		animation_player.play("dash")
		
		
	#Ruch
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * Global.speed

	move_and_slide()

#Atak - melee
func Atak():
	#Zabijanie Przeciwnika
	for o in melee_attack_area.get_overlapping_bodies():
		if o.is_in_group("Enemy"):
			
			o.health -= dmg_melee
		if o.is_in_group("Bullet"):
			#Animacja Rozbicia Bulleta TODO
			o.queue_free()
			
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

#Atak - Ranged
func _on_range_timer_timeout() -> void:
	range_cooldown = false

#Dash
func _startdash():
	Global.IsDashing = true
	lock_rotation = rotation
func _stopdash():
	Global.IsDashing = false

#Parry
func _on_parry_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		area.queue_free()
