extends Node2D

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


func _ready() -> void:
	#Timery
	cooldown_timer.wait_time = cooldown_waittime
	
	#Circle Timers
	circle_atak_timer.wait_time = circle_atak_waittime
	circle_lasting_timer.wait_time = circle_lasting_waittime
	
	#Spray Timer
	spray_lasting_timer.wait_time = spray_lasting_waittime
	spray_atak_timer.wait_time = spray_atak_waittime
	
func _process(delta: float) -> void:
	bullet_spawn.look_at(Player.global_position)
	if another_atak == true:
		match(x):
			1:
				Circle_Atak()
			2:
				Spray_Atak()

func Generate_Atak(y) -> int:
	var x = randi_range(1,y)
	return x

func Bullet_Spawn(rot,sideways,bullet_spawn,spread,scale1,speed):
	var bullet = bullet_path.instantiate()
	owner.add_child(bullet)
	bullet.transform = bullet_spawn.global_transform
	bullet.rotation = rot + deg_to_rad(randi_range(-45,45))
	print(bullet.rotation)
	bullet.speed = speed
	bullet.move_side = sideways
	var z = randi_range(1,2)
	if z == 1:
		bullet.directon = true
	else:
		bullet.directon = false
	bullet.scale = Vector2(scale1,scale1)
	
#Circle Atak
func Circle_Atak():
	if can_circle_atak == true:
		for i in range(0,16):
			Bullet_Spawn(18 * i,true,bullet_spawn,false,5,200)
		circle_atak_timer.start()
		can_circle_atak = false

#Spray Atak
func Spray_Atak():
	if can_spray_atak == true:
		can_spray_atak = false
		Bullet_Spawn(bullet_spawn.rotation,false,rotating_bullet_spawner,true,2,300)
		spray_atak_timer.start()

func _on_cooldown_timer_timeout() -> void:
	another_atak = true
	x = Generate_Atak(2)
	match(x):
		1:
			circle_lasting_timer.start()
			can_circle_atak = true
		2:
			spray_lasting_timer.start()
			can_spray_atak = true
	
#Circle Timery
func _on_circle_atak_timer_timeout() -> void:
	can_circle_atak = true

func _on_circle_lasting_timer_timeout() -> void:
	can_circle_atak = false
	another_atak = false
	cooldown_timer.start()

#Spray Timery
func _on_spray_lasting_timer_timeout() -> void:
	can_spray_atak = false
	another_atak = false
	cooldown_timer.start()


func _on_spray_atak_timer_timeout() -> void:
	can_spray_atak = true
