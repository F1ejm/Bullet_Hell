extends Node2D

@export var Player: CharacterBody2D
@export var main: Node2D

@onready var bullet_spawn                 = $Bullet_Spawn
@onready var rotating_bullet_spawner      = $Bullet_Spawn/Rotating_Bullet_Spawner
var bullet_path                          = preload("res://Enemy/bossowie/boss_3_bullet.tscn")

# który atak
var x: int

# flaga czy boss atakuje
var another_atak: bool = false

# Timery
@onready var cooldown_timer: Timer = $Cooldown_Timer
@onready var atak_timer:     Timer = $Atak_Timer
@onready var lasting_timer:  Timer = $Lasting_Timer

# interwały i czasy trwania
var cooldown_waittime = 2.0
var circle_interval   = 0.6
var circle_duration   = 6.0
var spray_interval    = 0.12
var spray_duration    = 5.0
var eryk_interval     = 0.2
var eryk_duration     = 6.0

# życie
var health: float = 80.0
@onready var progress_bar: ProgressBar = $ProgressBar

# teleport
var teleport = preload("res://Main/teleport.tscn")

func _ready() -> void:
	$".".rotation = 130
	# skalowanie HP
	health += health * 0.2 * (Global.Runda - 1)
	progress_bar.max_value = health
	progress_bar.value = health

	# animacja
	$AnimatedSprite2D.play("Idle")

	# ustaw timer cooldown
	cooldown_timer.wait_time = cooldown_waittime
	cooldown_timer.one_shot = true
	atak_timer.one_shot = true
	lasting_timer.one_shot = true

	# start pierwszego cooldownu
	cooldown_timer.start()

func _process(delta: float) -> void:
	progress_bar.value = health
	if health <= 0:
		_on_Death()

	# obrót spawnera
	if x == 3:
		bullet_spawn.rotation += deg_to_rad(1)
	else:
		bullet_spawn.look_at(Player.global_position)

# ─── ATAKI ──────────────────────────────────────

func _circle_attack() -> void:
	for i in range(20):
		var b = bullet_path.instantiate()
		main.add_child(b)
		b.global_transform = bullet_spawn.global_transform
		b.rotation = deg_to_rad(18 * i)
		b.speed = 200
		b.move_side = true
		b.change_timer = true
		b.directon = (randi_range(0,1)==1)
		b.scale = Vector2(5,5)

func _spray_attack() -> void:
	for i in range(4):
		var b = bullet_path.instantiate()
		main.add_child(b)
		b.global_transform = bullet_spawn.global_transform
		b.rotation = bullet_spawn.rotation + deg_to_rad(randi_range(-30,30))
		b.speed = 300
		b.move_side = false
		b.scale = Vector2(2.5,2.5)

func _eryk_attack() -> void:
	for i in range(8):
		var b = bullet_path.instantiate()
		main.add_child(b)
		b.global_transform = bullet_spawn.global_transform
		b.rotation = bullet_spawn.rotation + deg_to_rad(45 * i)
		b.speed = 220
		b.move_side = true
		b.change_timer = false
		b.directon = true
		b.scale = Vector2(3,3)

# ─── GENERATOR ATAKU ────────────────────────────

func _generate_attack() -> int:
	randomize()
	return randi_range(1,3)

# ─── HANDLERY TIMERÓW ──────────────────────────






# ─── ŚMIERĆ ─────────────────────────────────────

func hit(dmg: float) -> void:
	health -= dmg

func _on_Death() -> void:
	Global.VDolce += 20
	var t = teleport.instantiate()
	main.add_child(t)
	t.global_position = global_position
	Player.get_node("Node2D/Camera2D").screen_shake(13,4,1)
	AudioManager.play_dungeon_and_shop_music(-20)
	queue_free()


func _on_lasting_timer_timeout() -> void:
		# koniec fazy ataku
	another_atak = false
	$AnimatedSprite2D.play("Idle")
	# usuń pociski
	for b in get_tree().get_nodes_in_group("Boss_Bullet"):
		b.queue_free()
	# start cooldownu do następnego ataku
	cooldown_timer.start()






func _on_atak_timer_timeout() -> void:
	if not another_atak:
		return
	# wykonaj atak
	match x:
		1: _circle_attack()
		2: _spray_attack()
		3: _eryk_attack()
	# restartuj interwał
	atak_timer.start()


func _on_cooldown_timer_timeout() -> void:
	# wchodzimy w fazę ataku
	x = _generate_attack()
	another_atak = true
	$AnimatedSprite2D.play("Attack")
	match x:
		1:
			atak_timer.wait_time = circle_interval
			lasting_timer.wait_time = circle_duration
		2:
			atak_timer.wait_time = spray_interval
			lasting_timer.wait_time = spray_duration
		3:
			atak_timer.wait_time = eryk_interval
			lasting_timer.wait_time = eryk_duration
	# start ataku
	atak_timer.start()
	lasting_timer.start()
