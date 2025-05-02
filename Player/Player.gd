extends CharacterBody2D

@onready var ui: Control = $CanvasLayer/UI
@onready var node_2d: Node2D = $Node2D
@onready var melee_attack_area: Area2D = $Node2D/Melee_attack_area
@onready var timer: Timer = $Collision_Timer
@onready var atak_timer: Timer = $Atak_Timer

@onready var sprite_2d: Sprite2D = $Node2D/Melee_attack_area/Sprite2D

#Zmienna Określająca czy collision shape do zabijania jest aktywny
var collision_atak: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować
var atak_cooldown: bool = false

func _ready() -> void:
	ui.visible = false

func _physics_process(delta):
	#Atak

	if Input.is_action_just_pressed("atak") and atak_cooldown == false:
		atak_timer.stop()
		atak_timer.start()
		timer.stop()
		timer.start()
		collision_atak = true
		atak_cooldown = true
		
	if collision_atak == true:
		sprite_2d.visible = true #Zamiast Tego Animacja TODO
		Atak()
	
	#Ruch
	if Global.stop == true:
		return
	
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * Global.speed

	move_and_slide()

#Atak
func Atak():
	#Zabijanie Przeciwnika
	for o in melee_attack_area.get_overlapping_bodies():
		if o.is_in_group("Enemy"):
			o.queue_free()

#Atak
func _on_timer_timeout() -> void:
	sprite_2d.visible = false #Zamiast Tego Animacja TODO
	collision_atak = false
func _on_atak_timer_timeout() -> void:
	atak_cooldown = false
