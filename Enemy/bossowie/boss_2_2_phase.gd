extends Area2D

var Player: CharacterBody2D
var main: Node2D

var teleport = preload("res://Main/teleport.tscn")

@onready var bullet_spawn: Node2D = $Bullet_Spawn
@onready var rotating_bullet_spawner: Node2D = $Bullet_Spawn/Rotating_Bullet_Spawner

var bullet_path = preload("res://Enemy/bossowie/boss_2_bullet.tscn")

#Timery
var another_atak: bool = true
@onready var cooldown_timer: Timer = $Cooldown_Timer
@onready var lasting_timer: Timer = $Lasting_Timer
@onready var atak_timer: Timer = $Atak_Timer
var cooldown_waittime: float = 2

var x: int

#Timery
var pierwszy_atak_waittime: float = 1
var pierwszy_lasting_waittime: float = 6
var can_pierwszy_atak: bool = true

var player_position

var drugi_lasting_waittime: float = 6
var drugi_atak_waittime: float = 1.5
var can_drugi_atak: bool = true

var homing_missle: PackedScene = preload("res://Enemy/bossowie/boss_2_homing_missle.tscn")

var trzeci_lasting_waittime: float = 6
var trzeci_atak_waittime: float = 1.5
var can_trzeci_atak: bool = true

#Zycie i wszystko do zycia
var health: float = 100
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
		Death()
	if x == 3:
		for o in get_overlapping_bodies():
			if o.is_in_group("Player") and Global.IsDashing != true and Global.immune != true:
				o.Dmg_Func(1)
	
	bullet_spawn.look_at(Player.global_position)
	
	if another_atak == true:
		match(x):
			1:
				atak_timer.wait_time = pierwszy_atak_waittime
				First_Atak()
				position = position.move_toward(player_position,delta * 800)
			2:
				atak_timer.wait_time = drugi_atak_waittime
				Second_Atak()
				position = position.move_toward(player_position,delta * 1200)
			3:
				atak_timer.wait_time = trzeci_atak_waittime
				Third_Atak()
				position = position.move_toward(player_position,delta * 1500)
				
func Generate_Atak(y) -> int:
	randomize()
	var x = randi_range(1,y)
	return x
	
func First_Atak():
	if can_pierwszy_atak == true:
		player_position = Player.global_position
		for o in get_tree().get_nodes_in_group("Boss_Bullet"):
			o.queue_free()
		
		#bullet
		for i in range(1,21):
			#Spawn Bulletu
			var bullet = bullet_path.instantiate()
			main.add_child(bullet)
			bullet.transform = rotating_bullet_spawner.global_transform
			bullet.rotation = deg_to_rad(18 * i)
			bullet.speed = 500
			bullet.move_side = false
			bullet.change_timer = false
			bullet.scale = Vector2(3,3)
		
		bullet_spawn.rotation += deg_to_rad(60)
		
		for i in range(1,6):
			bullet_spawn.rotation -= deg_to_rad(20)
			#spawn
			var bullet2 = bullet_path.instantiate()
			add_child(bullet2)
			bullet2.global_transform = rotating_bullet_spawner.global_transform
			bullet2.speed = 200
			bullet2.move_side = false
			bullet2.change_timer = false
			bullet2.scale = Vector2(5,5)
			
		can_pierwszy_atak = false
		atak_timer.start()

func Second_Atak():
	if can_drugi_atak == true:
		player_position = Player.global_position
		
		#bullet
		for i in range(1,21):
			#Spawn Bulletu
			var bullet = homing_missle.instantiate()
			add_child(bullet)
			bullet.global_transform = global_transform
			bullet.rotation = deg_to_rad(18 * i)
			bullet.scale = Vector2(4,4)
			bullet.atak_timer.wait_time = 0.5 
			bullet.atak_timer.start()
			bullet.main = main
			bullet.Player = Player
		
		can_drugi_atak = false
		atak_timer.start()

func Third_Atak():
	if can_trzeci_atak == true:
		player_position = Player.global_position
		
		can_trzeci_atak = false
		atak_timer.start()

	
func _on_cooldown_timer_timeout() -> void:
	for o in get_tree().get_nodes_in_group("Boss_Bullet"):
		o.queue_free()
	can_pierwszy_atak = true
	can_drugi_atak = true
	can_trzeci_atak = true
	another_atak = true
	x = Generate_Atak(3)
	match(x):
		1:
			lasting_timer.wait_time = pierwszy_lasting_waittime
		2:
			lasting_timer.wait_time = drugi_lasting_waittime
		3:
			lasting_timer.wait_time = trzeci_lasting_waittime
	lasting_timer.start()
			
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
			
func _on_lasting_timer_timeout() -> void:
	can_pierwszy_atak = false
	can_drugi_atak = false
	can_trzeci_atak = false
	another_atak = false
	cooldown_timer.start()


func Death():
	Global.VDolce += 35
	var teleportacja = teleport.instantiate()
	main.add_child(teleportacja)
	teleportacja.global_position = self.global_position
	queue_free()
