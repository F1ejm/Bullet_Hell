extends Node2D

@onready var bullet_spawn: Node2D = $Bullet_Spawn
var bullet_path = preload("res://Enemy/bossowie/boss_1_bullet.tscn")

#variable ktory wybiera ktory atak wyprowadzic
var x: int

#Timery
var another_atak: bool = true
@onready var cooldown_timer: Timer = $Cooldown_Timer
var cooldown_waittime: float = 5

@onready var circle_lasting_timer: Timer = $Circle_Lasting_Timer
@onready var circle_atak_timer: Timer = $Circle_Atak_Timer
var circle_atak_waittime: float = 1
var circle_lasting_waittime: float = 10
var can_circle_atak: bool = true

func _ready() -> void:
	#Timery
	cooldown_timer.wait_time = cooldown_waittime
	
	#Circle Timers
	circle_atak_timer.wait_time = circle_atak_waittime
	circle_lasting_timer.wait_time = circle_lasting_waittime
	
func _process(delta: float) -> void:
	print(another_atak)
	if another_atak == true:
		match(x):
			1:
				Circle_Atak()

func Generate_Atak(y) -> int:
	var x = randi_range(1,y)
	return x

func Bullet_Spawn(rot,sideways):
	var bullet = bullet_path.instantiate()
	owner.add_child(bullet)
	bullet.transform = bullet_spawn.global_transform
	bullet.rotation = rot
	bullet.speed = 200
	bullet.move_side = sideways
	var z = randi_range(1,2)
	if z == 1:
		bullet.directon = true
	else:
		bullet.directon = false
	bullet.scale.x = 5
	bullet.scale.y = 5
	
func Circle_Atak():
	if can_circle_atak == true:
		for i in range(0,16):
			Bullet_Spawn(18 * i,true)
		circle_atak_timer.start()
		can_circle_atak = false

func _on_cooldown_timer_timeout() -> void:
	another_atak = true
	can_circle_atak = true
	x = Generate_Atak(1)
	circle_lasting_timer.start()
	

func _on_circle_atak_timer_timeout() -> void:
	can_circle_atak = true

func _on_circle_lasting_timer_timeout() -> void:
	can_circle_atak = false
	another_atak = false
	cooldown_timer.start()
