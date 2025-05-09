extends Area2D

@export var Player: CharacterBody2D

@onready var bullet_spawn: Node2D = $Bullet_Spawn
@onready var rotating_bullet_spawner: Node2D = $Bullet_Spawn/Rotating_Bullet_Spawner
var bullet_path = preload("res://Enemy/bossowie/boss_2_bullet.tscn")

var second_phase_path = preload("res://Enemy/bossowie/boss_2_2_phase.tscn")

@export var main: Node2D

#variable ktory wybiera ktory atak wyprowadzic
var x: int

#Timery
var another_atak: bool = true
@onready var cooldown_timer: Timer = $Cooldown_Timer
@onready var lasting_timer: Timer = $Lasting_Timer
@onready var atak_timer: Timer = $Atak_Timer
var cooldown_waittime: float = 3

#Pierwszy - Homing
@onready var pierwszy_atak_node: Node2D = $pierwszy_atak_node
@onready var pivot: Node2D = $pierwszy_atak_node/pivot

var pierwszy_atak_waittime: float = 1
var pierwszy_lasting_waittime: float = 10
var can_pierwszy_atak: bool = true

#Drugi - supressing fire
@onready var drugi_atak_node: Node2D = $drugi_atak_node
@onready var pierwszy: Node2D = $drugi_atak_node/Pierwszy

@onready var drugi_atak_node_2: Node2D = $drugi_atak_node2
@onready var drugi: Node2D = $drugi_atak_node2/Drugi

@onready var drugi_atak_node_3: Node2D = $drugi_atak_node3
@onready var trzeci: Node2D = $drugi_atak_node3/Trzeci

@onready var drugi_atak_node_4: Node2D = $drugi_atak_node4
@onready var czwarty: Node2D = $drugi_atak_node4/Czwarty


var drugi_lasting_waittime: float = 5
var drugi_atak_waittime: float = 0.2
var can_drugi_atak: bool = true

#trzeci
var trzeci_node: PackedScene = preload("res://Enemy/bossowie/boss_2_trzeci_atak.tscn")

var trzeci_lasting_waittime: float = 10
var trzeci_atak_waittime: float = 0.5
var can_trzeci_atak: bool = true

#czwarty
var czwarty_lasting_waittime: float = 7
var czwarty_atak_waittime: float = 0.7
var can_czwarty_atak: bool = true

#Zycie i wszystko do zycia
var health: int = 100
@onready var progress_bar: ProgressBar = $ProgressBar
var can_be_hit: bool = true

func _ready() -> void:
	#animacje TODO
	#health bar
	progress_bar.max_value = health
	
	#Timery
	cooldown_timer.wait_time = cooldown_waittime
	
	
func _process(delta: float) -> void:
	progress_bar.value = health
	if health <= 0:
		Second_Phase()
	
	bullet_spawn.look_at(Player.global_position)
	pierwszy_atak_node.look_at(Player.global_position)
	if x == 1:
		pierwszy_atak_node.visible = true
	else:
		pierwszy_atak_node.visible = false
	
	if another_atak == true:
		match(x):
			1:
				pierwszy_atak_node.global_position += Vector2.RIGHT.rotated(pierwszy_atak_node.rotation) * 200 * delta
				atak_timer.wait_time = pierwszy_atak_waittime
				First_Atak()
			2:
				drugi_atak_node.rotation += deg_to_rad(0.8)
				drugi_atak_node_2.rotation += deg_to_rad(-0.8)
				drugi_atak_node_3.rotation += deg_to_rad(0.8)
				drugi_atak_node_4.rotation += deg_to_rad(-0.8)
				atak_timer.wait_time = drugi_atak_waittime
				Second_Atak()
			3:
				atak_timer.wait_time = trzeci_atak_waittime
				Third_Atak()
			4:
				atak_timer.wait_time = czwarty_atak_waittime
				Fourth_Atak()
				
func Generate_Atak(y) -> int:
	var x = randi_range(1,y)
	return x
	
#pierwszy atak
func First_Atak():
	#wystrzał node'a
	if can_pierwszy_atak == true:
		for i in range(1,21):
			#Spawn Bulletu
			var bullet = bullet_path.instantiate()
			owner.add_child(bullet)
			bullet.transform = pierwszy_atak_node.global_transform
			bullet.rotation = deg_to_rad(18 * i)
			bullet.speed = 330
			bullet.move_side = false
			bullet.change_timer = false
			bullet.scale = Vector2(3,3)
		atak_timer.start()
		can_pierwszy_atak = false
	#strzelanie noda
	
#drugi atak
func Second_Atak():
	if can_drugi_atak == true:
		#bullet spawn
		var bullet = bullet_path.instantiate()
		owner.add_child(bullet)
		bullet.transform = pierwszy.global_transform
		bullet.speed = 1000
		bullet.move_side = false
		bullet.change_timer = false
		bullet.scale = Vector2(3,3)
		
		var bullet2 = bullet_path.instantiate()
		owner.add_child(bullet2)
		bullet2.transform = drugi.global_transform
		bullet2.speed = 1000
		bullet2.move_side = false
		bullet2.change_timer = false
		bullet2.scale = Vector2(3,3)
		
		var bullet3 = bullet_path.instantiate()
		owner.add_child(bullet3)
		bullet3.transform = trzeci.global_transform
		bullet3.speed = 1000
		bullet3.move_side = false
		bullet3.change_timer = false
		bullet3.scale = Vector2(3,3)
		
		
		var bullet4 = bullet_path.instantiate()
		owner.add_child(bullet4)
		bullet4.transform = czwarty.global_transform
		bullet4.speed = 1000
		bullet4.move_side = false
		bullet4.change_timer = false
		bullet4.scale = Vector2(3,3)
		
		atak_timer.start()
		can_pierwszy_atak = false
		
#trzeci atak
func Third_Atak():
	if can_trzeci_atak == true:
		#atak w playera
		var atak = trzeci_node.instantiate()
		owner.add_child(atak)
		atak.Player = Player.global_position
		atak.transform = rotating_bullet_spawner.global_transform
		
		can_trzeci_atak = false
		atak_timer.start()
		
#Czwarty atak
func Fourth_Atak():
	if can_czwarty_atak == true:
		bullet_spawn.rotation += deg_to_rad(60)
		
		for i in range(1,12):
			bullet_spawn.rotation -= deg_to_rad(10)
			#spawn
			var bullet = bullet_path.instantiate()
			owner.add_child(bullet)
			bullet.transform = rotating_bullet_spawner.global_transform
			bullet.speed = 500
			bullet.move_side = false
			bullet.change_timer = false
			bullet.scale = Vector2(3,3)
		
		can_czwarty_atak = false
		atak_timer.start()

func _on_cooldown_timer_timeout() -> void:
	$AnimatedSprite2D.play("Idle")
	can_pierwszy_atak = true
	can_drugi_atak = true
	can_trzeci_atak = true
	can_czwarty_atak = true
	another_atak = true
	pierwszy_atak_node.global_position = global_position
	x = Generate_Atak(4)
	match(x):
		1:
			lasting_timer.wait_time = pierwszy_lasting_waittime
		2:
			drugi_atak_node.look_at(Player.global_position)
			drugi_atak_node_2.look_at(Player.global_position)
			drugi_atak_node_3.look_at(Player.global_position)
			drugi_atak_node_4.look_at(Player.global_position)
			drugi_atak_node.rotation -= deg_to_rad(60)
			drugi_atak_node_2.rotation += deg_to_rad(60)
			drugi_atak_node_3.rotation += deg_to_rad(120)
			drugi_atak_node_4.rotation -= deg_to_rad(120)
			lasting_timer.wait_time = drugi_lasting_waittime
		3:
			lasting_timer.wait_time = trzeci_lasting_waittime
		4:
			lasting_timer.wait_time = czwarty_lasting_waittime
	lasting_timer.start()
		
func Second_Phase():
	# Animacje smierci i sfx etc. TODO
	var second_phase = second_phase_path.instantiate()
	owner.add_child(second_phase)
	second_phase.transform = global_transform
	second_phase.Player = Player
	second_phase.main = main
	
	queue_free()

#Timery
func _on_atak_timer_timeout() -> void:
	$AnimatedSprite2D.play("Idle")
	match(x):
		1:
			can_pierwszy_atak = true
		2:
			can_drugi_atak = true
		3:
			can_trzeci_atak = true
		4:
			can_czwarty_atak = true

func _on_lasting_timer_timeout() -> void:
	$AnimatedSprite2D.play("smiech")
	can_pierwszy_atak = false
	can_drugi_atak = false
	can_trzeci_atak = false
	can_czwarty_atak = false
	another_atak = false
	cooldown_timer.start()
	
