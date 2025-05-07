extends Area2D

@export var Player: CharacterBody2D

@onready var bullet_spawn: Node2D = $Bullet_Spawn
@onready var rotating_bullet_spawner: Node2D = $Bullet_Spawn/Rotating_Bullet_Spawner
var bullet_path = preload("res://Enemy/bossowie/boss_1_bullet.tscn")

#variable ktory wybiera ktory atak wyprowadzic
var x: int

#Timery
var another_atak: bool = true
@onready var cooldown_timer: Timer = $Cooldown_Timer
var cooldown_waittime: float = 3

#Circle
@onready var circle_lasting_timer: Timer = $Circle_Lasting_Timer
@onready var circle_atak_timer: Timer = $Circle_Atak_Timer
var circle_atak_waittime: float = 1
var circle_lasting_waittime: float = 10
var can_circle_atak: bool = true

#Spray
@onready var spray_lasting_timer: Timer = $Spray_Lasting_Timer
@onready var spray_atak_timer: Timer = $Spray_Atak_Timer
var spray_lasting_waittime: float = 6
var spray_atak_waittime: float = 0.05
var can_spray_atak: bool = true

#Eryczkowy
@onready var eryczkowy_atak_timer: Timer = $Eryczkowy_Atak_Timer
@onready var eryczkowy_lasting_timer: Timer = $Eryczkowy_Lasting_Timer
var eryczkowy_lasting_waittime: float = 10
var eryczkowy_atak_waittime: float = 0.05
var can_eryczkowy_atak: bool = true

#Zycie i wszystko do zycia
var health: int = 50
var can_be_hit: bool = false
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	#health bar
	progress_bar.max_value = health
	
	#Timery
	cooldown_timer.wait_time = cooldown_waittime
	
	#Circle Timers
	circle_atak_timer.wait_time = circle_atak_waittime
	circle_lasting_timer.wait_time = circle_lasting_waittime
	
	#Spray Timer
	spray_lasting_timer.wait_time = spray_lasting_waittime
	spray_atak_timer.wait_time = spray_atak_waittime
	
	#Eryczkowy Timer
	eryczkowy_atak_timer.wait_time = eryczkowy_atak_waittime
	eryczkowy_lasting_timer.wait_time = eryczkowy_lasting_waittime
	
func _process(delta: float) -> void:
	progress_bar.value = health
	
	if health <= 0:
		Death()
	
	if x == 3:
		bullet_spawn.rotation += deg_to_rad(0.5)
	else:
		bullet_spawn.look_at(Player.global_position)
	if another_atak == true:
		match(x):
			1:
				Circle_Atak()
			2:
				Spray_Atak()
			3:
				Eryk_Atak()

func Generate_Atak(y) -> int:
	var x = randi_range(1,y)
	return x
	
#Circle Atak
func Circle_Atak():
	if can_circle_atak == true:
		for i in range(1,21):
			#Spawn Bulletu
			var bullet = bullet_path.instantiate()
			owner.add_child(bullet)
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
			
		circle_atak_timer.start()
		can_circle_atak = false

#Spray Atak
func Spray_Atak():
	if can_spray_atak == true:
		#Spawn Bulletu
		var bullet = bullet_path.instantiate()
		owner.add_child(bullet)
		bullet.transform = bullet_spawn.global_transform
		bullet.rotation = bullet_spawn.rotation+ deg_to_rad(randi_range(-45,45))
		print(bullet.rotation)
		bullet.speed = 400
		bullet.move_side = false
		bullet.scale = Vector2(2,2)
		
		can_spray_atak = false
		spray_atak_timer.start()
		
#Eryczkowy Atak
func Eryk_Atak():
	if can_eryczkowy_atak == true:
		for i in range(1,5):
			#Spawn Bulletu
			var bullet = bullet_path.instantiate()
			owner.add_child(bullet)
			bullet.transform = bullet_spawn.global_transform
			bullet.rotation = bullet_spawn.rotation + deg_to_rad(90 * i)
			bullet.speed = 200
			bullet.move_side = true
			bullet.change_timer = false
			bullet.directon = true
			bullet.scale = Vector2(3,3)
		eryczkowy_atak_timer.start()
		can_eryczkowy_atak = false

func _on_cooldown_timer_timeout() -> void:
	another_atak = true
	can_be_hit = false
	x = Generate_Atak(3)
	match(x):
		1:
			circle_lasting_timer.start()
			can_circle_atak = true
		2:
			spray_lasting_timer.start()
			can_spray_atak = true
		3:
			eryczkowy_lasting_timer.start()
			can_eryczkowy_atak = true
			
	
#Circle Timery
func _on_circle_atak_timer_timeout() -> void:
	can_circle_atak = true

func _on_circle_lasting_timer_timeout() -> void:
	can_circle_atak = false
	another_atak = false
	can_be_hit = true
	cooldown_timer.start()

#Spray Timery
func _on_spray_lasting_timer_timeout() -> void:
	can_spray_atak = false
	another_atak = false
	can_be_hit = true
	cooldown_timer.start()


func _on_spray_atak_timer_timeout() -> void:
	can_spray_atak = true

#Eryczek Timer
func _on_eryczkowy_atak_timer_timeout() -> void:
	can_eryczkowy_atak = true


func _on_eryczkowy_lasting_timer_timeout() -> void:
	can_eryczkowy_atak = false
	another_atak = false
	can_be_hit = true
	cooldown_timer.start()
	
		
func Death():
	# Animacje smierci i sfx etc. TODO
	queue_free()
