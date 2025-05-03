extends CharacterBody2D

@onready var ui: Control = $CanvasLayer/UI
@onready var node_2d: Node2D = $Node2D
@onready var melee_attack_area: Area2D = $Node2D/Melee_attack_area
@onready var timer: Timer = $Collision_Timer
@onready var atak_timer: Timer = $Atak_Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sprite_2d: Sprite2D = $Node2D/Melee_attack_area/Sprite2D

#Zmienna Określająca czy collision shape do zabijania jest aktywny
var collision_atak: bool = false

#Zmienna Okreslajaca czy atak jest na cooldawnie: False-możesz atakować
var atak_cooldown: bool = false

#variable do lockowwania rotacji przy dashu
var lock_rotation


func _ready() -> void:
	atak_timer.wait_time = Global.AtakCooldown

func _physics_process(delta):
	if Global.stop == true:
		return
	#Atak
	
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
		Atak()
	
	#Dash
	if Global.IsDashing:
		rotation = lock_rotation
		var current_time = animation_player.current_animation_position
		var value = animation_player.get_animation("dash").value_track_interpolate(1,current_time)
		self.position = self.position - ((self.global_position - $Pivot.global_position) * value.x * delta * 3)

	if Input.is_action_just_pressed("dash") and Global.IsDashing == false and Global.Stamina > 0:
		Global.Stamina -= Global.Koszt_Dasha
		animation_player.play("dash")
		
		
	#Ruch
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * Global.speed

	move_and_slide()

#Atak
func Atak():
	#Zabijanie Przeciwnika
	for o in melee_attack_area.get_overlapping_bodies():
		if o.is_in_group("Enemy"):
			#Pieniądze
			var monetki = randi_range(0,2)
			Global.VDolce += monetki
			
			o.queue_free()

#Atak
func _on_timer_timeout() -> void:
	sprite_2d.visible = false #Zamiast Tego Animacja TODO
	collision_atak = false
func _on_atak_timer_timeout() -> void:
	atak_cooldown = false

#Dash
func _startdash():
	Global.IsDashing = true
	lock_rotation = rotation
func _stopdash():
	Global.IsDashing = false
