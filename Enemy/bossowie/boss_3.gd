extends Node2D

@export var Player: CharacterBody2D
@export var main: Node2D

@onready var bullet_spawn                 = $Bullet_Spawn
@onready var rotating_bullet_spawner      = $Bullet_Spawn/Rotating_Bullet_Spawner
var bullet_path                          = preload("res://Enemy/bossowie/boss_3_bullet.tscn")
var spiral_bullet_scene = preload("res://Enemy/Naprowadzający/Bullets/naprowadzający_bullet.tscn")
# który atak
var x: int

# flaga czy boss atakuje
var another_atak: bool = false

# Timery
@onready var cooldown_timer: Timer = $Cooldown_Timer
@onready var atak_timer:     Timer = $Atak_Timer
@onready var lasting_timer:  Timer = $Lasting_Timer
@onready var rage_timer:  Timer = $Rage_Timer
# interwały i czasy trwania
var atack_speed = 1
var cooldown_waittime = 1.0
var circle_interval   = 0.5 * atack_speed
var circle_duration   = 7.0
var spray_interval    = 0.2 * atack_speed
var spiral_angle := 0.0  
var spray_duration    = 3.0
var eryk_interval     = 0.2 * atack_speed
var eryk_duration     = 7.0
var can_rage = true
var can_be_hit
var max_health = health * 0.2 * (Global.Runda - 1)
# życie
var health: float = 130.0
@onready var progress_bar: ProgressBar = $ProgressBar

# teleport
var teleport = preload("res://Main/teleport.tscn")

func _ready() -> void:
	can_be_hit = true
	$".".global_rotation = 0
	can_rage = true
	health += health * 0.2 * (Global.Runda - 1)
	max_health = health
	progress_bar.max_value = health
	progress_bar.value = health

	$bluescreen.visible = false
	$AnimatedSprite2D.play("Idle")

	cooldown_timer.wait_time = cooldown_waittime
	cooldown_timer.one_shot = true
	atak_timer.one_shot = true
	lasting_timer.one_shot = true

	cooldown_timer.start()

func _process(delta: float) -> void:
	progress_bar.value = health
	if health < (0.4 * max_health):
		if can_rage == true:
			rage()
			
	if health <= 0:
		_on_Death()

	# obrót spawnera
	if x == 3:
		bullet_spawn.rotation += deg_to_rad(1)
	else:
		bullet_spawn.look_at(Player.global_position)
	if can_rage == false:
		cooldown_waittime = 0.5

# ─── ATAKI ──────────────────────────────────────

func _circle_attack() -> void:
	var bullet_count = 18
	var spread_angle = 90 
	var base_angle = (Player.global_position - bullet_spawn.global_position).angle()
	var start_angle = base_angle - deg_to_rad(spread_angle / 2)

	for i in range(bullet_count):
		var b = bullet_path.instantiate()
		main.add_child(b)
		b.global_position = bullet_spawn.global_position
		var angle = start_angle + deg_to_rad(spread_angle) * i / (bullet_count - 1)
		b.rotation = angle
		b.speed = 500 * atack_speed
		b.move_side = false
		b.scale = Vector2(3, 3)

var gap_index := 0  # indeks dziury w okręgu
func _spiral_attack() -> void:
	var bullet_count = 30
	var angle_step = TAU / bullet_count

	# Strzelamy w każdą stronę oprócz gap_index
	for i in range(bullet_count):
		if i == gap_index:
			continue  # zostaw dziurę
		var b = bullet_path.instantiate()
		main.add_child(b)
		b.global_position = bullet_spawn.global_position
		b.rotation = i * angle_step
		if can_rage == true:
			b.speed = 300
		if can_rage == false:
			b.speed = 450
	
		b.move_side = false
		b.scale = Vector2(2.0, 2.0)

	# Przesuń dziurę w prawo (wiruje)
	gap_index = (gap_index + 1) % bullet_count

func _eryk_attack() -> void:
	for i in range(8):
		var b = bullet_path.instantiate()
		main.add_child(b)
		b.global_transform = bullet_spawn.global_transform
		b.rotation = bullet_spawn.rotation + deg_to_rad(45 * i)
		b.speed = 220 * atack_speed
		b.move_side = true
		b.change_timer = false
		b.directon = true
		b.scale = Vector2(3,3)
func _naprowadzający_attack():
	var bullet_count = 12
	var angle_step = TAU / bullet_count
	var radius = 100
	var center = bullet_spawn.global_position

	for i in range(bullet_count):
		var angle = i * angle_step
		var offset = Vector2(cos(angle), sin(angle)) * radius
		
		var bullet = spiral_bullet_scene.instantiate()
		main.add_child(bullet)
		
		# Ustaw pozycję w spirali
		bullet.global_position = center + offset
		bullet.rotation = angle
		bullet.speed = 2.5  # Bullet będzie się zbliżał – zależnie od jego wewnętrznej logiki

# ─── GENERATOR ATAKU ────────────────────────────

func _generate_attack() -> int:
	randomize()
	return randi_range(1,3)

# ─── RAGE──────────────────────────
func rage():
	$AnimatedSprite2D.play("Rage")
	can_rage = false
	$bluescreen.visible = true
	rage_timer.start()
	get_tree().paused = true





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
		2: _spiral_attack()
		3: _eryk_attack()
		4: _naprowadzający_attack()
	# restartuj interwał
	atak_timer.start()


func _on_cooldown_timer_timeout() -> void:
	# wchodzimy w fazę ataku
	x = _generate_attack()
	another_atak = true
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
		4:
			atak_timer.wait_time = 0.1
			lasting_timer.wait_time = 3.0
	# start ataku
	atak_timer.start()
	lasting_timer.start()


func _on_rage_timer_timeout() -> void:
	$bluescreen.visible = false
	atack_speed = 2.3
	get_tree().paused = false
