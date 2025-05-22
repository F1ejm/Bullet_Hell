extends Area2D

@export var Player: CharacterBody2D
var main

@onready var bullet_spawn: Node2D = $Bullet_Spawn
@onready var rotating_bullet_spawner: Node2D = $Bullet_Spawn/Rotating_Bullet_Spawner
var bullet_path = preload("res://Enemy/bossowie/boss_1_bullet.tscn")

#variable ktory wybiera ktory atak wyprowadzic
var x: int

#Timery
var another_atak: bool = true
@onready var cooldown_timer: Timer = $Cooldown_Timer
@onready var lasting_timer: Timer = $Lasting_Timer
@onready var atak_timer: Timer = $Atak_Timer
var cooldown_waittime: float = 3

#Circle
var circle_atak_waittime: float = 1
var circle_lasting_waittime: float = 10
var can_circle_atak: bool = true

#Spray
var spray_lasting_waittime: float = 8.5
var spray_atak_waittime: float = 0.05
var can_spray_atak: bool = true

#Eryczkowy
var eryczkowy_lasting_waittime: float = 10
var eryczkowy_atak_waittime: float = 0.05
var can_eryczkowy_atak: bool = true

#Zycie i wszystko do zycia
var health: float = 50
var can_be_hit: bool = false
@onready var progress_bar: ProgressBar = $ProgressBar

var teleport = preload("res://Main/teleport.tscn")

func _ready() -> void:
	Global.boss_round = true
	health = health + (0.2 * health * (Global.Runda - 1))
	rotation = rotation - global_rotation
	#animacje
	$AnimatedSprite2D.play("Idle")
	#health bar
	progress_bar.max_value = health
	
	#Timery
	cooldown_timer.wait_time = cooldown_waittime
	
func _process(delta: float) -> void:
	progress_bar.value = health
	
	if health <= 0:
		Death()
	
	if x == 3:
		bullet_spawn.rotation += deg_to_rad(0.3)
	else:
		bullet_spawn.look_at(Player.global_position)
	if another_atak == true:
		match(x):
			1:
				atak_timer.wait_time = circle_atak_waittime
				Circle_Atak()
				
			2:
				atak_timer.wait_time = spray_atak_waittime
				Spray_Atak()
				
			3:
				atak_timer.wait_time = eryczkowy_atak_waittime
				Eryk_Atak()
				

func Generate_Atak(y) -> int:
	randomize()
	var x = randi_range(1,y)
	return x
	
#Circle Atak
func Circle_Atak():
	if can_circle_atak == true:
		for i in range(1,21):
			#Spawn Bulletu
			var bullet = bullet_path.instantiate()
			main.add_child(bullet)
			bullet.transform = bullet_spawn.global_transform
			bullet.rotation = deg_to_rad(18 * i)
			bullet.speed = 200
			bullet.move_side = true
			bullet.change_timer = true
			var z = randi_range(1,2)
			if z == 1:
				bullet.directon = true
			else:
				bullet.directon = false
			bullet.scale = Vector2(5,5)
			
		atak_timer.start()
		can_circle_atak = false

#Spray Atak
func Spray_Atak():
	if can_spray_atak == true:
		#Spawn Bulletu
		var bullet = bullet_path.instantiate()
		main.add_child(bullet)
		bullet.transform = bullet_spawn.global_transform
		bullet.rotation = bullet_spawn.rotation+ deg_to_rad(randi_range(-45,45))
		bullet.speed = 400
		bullet.move_side = false
		bullet.scale = Vector2(2,2)
		
		can_spray_atak = false
		atak_timer.start()
		
#Eryczkowy Atak
func Eryk_Atak():
	if can_eryczkowy_atak == true:
		for i in range(1,5):
			#Spawn Bulletu
			var bullet = bullet_path.instantiate()
			main.add_child(bullet)
			bullet.transform = bullet_spawn.global_transform
			bullet.rotation = bullet_spawn.rotation + deg_to_rad(90 * i)
			bullet.speed = 200
			bullet.move_side = true
			bullet.change_timer = false
			bullet.directon = true
			bullet.scale = Vector2(3,3)
		atak_timer.start()
		can_eryczkowy_atak = false

func _on_cooldown_timer_timeout() -> void:
	another_atak = true
	can_be_hit = false
	$AnimatedSprite2D.play("Idle")
	x = Generate_Atak(3)
	match(x):
		1:
			can_circle_atak = true
			lasting_timer.wait_time = circle_lasting_waittime
		2:
			can_spray_atak = true
			lasting_timer.wait_time = spray_lasting_waittime
		3:
			can_eryczkowy_atak = true
			lasting_timer.wait_time = eryczkowy_lasting_waittime
	lasting_timer.start()
			
	
#Timery
func _on_circle_atak_timer_timeout() -> void:
	match(x):
		1:
			can_circle_atak = true
		2:
			can_spray_atak = true
		3:
			can_eryczkowy_atak = true

func _on_circle_lasting_timer_timeout() -> void:
	can_circle_atak = false
	can_spray_atak = false
	can_eryczkowy_atak = false
	another_atak = false
	can_be_hit = true
	$AnimatedSprite2D.play("niszczenie")
	cooldown_timer.start()
	
	for o in get_tree().get_nodes_in_group("Boss_Bullet"):
		o.queue_free()
	
		
func Death():
	# Animacje smierci i sfx etc. TODO
	Global.VDolce += 20
	var teleportacja = teleport.instantiate()
	main.add_child(teleportacja)
	teleportacja.global_position = self.global_position
	Player.get_node("Node2D/Camera2D").screen_shake(13, 4,false)
	AudioManager.play_dungeon_and_shop_music(-20)
	Global.boss_round = false
	queue_free()
