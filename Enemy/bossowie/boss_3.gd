extends Node2D

@export var Player: CharacterBody2D
@export var main: Node2D

@onready var bullet_spawn: Node2D = $Bullet_Spawn
@onready var rotating_bullet_spawner: Node2D = $Bullet_Spawn/Rotating_Bullet_Spawner
var bullet_path = preload("res://Enemy/bossowie/boss_3_bullet.tscn")

# Wybór ataku
var x: int
var another_atak: bool = true

# Timery
@onready var cooldown_timer: Timer = $Cooldown_Timer
@onready var lasting_timer: Timer = $Lasting_Timer
@onready var atak_timer: Timer = $Atak_Timer
var cooldown_waittime: float = 3.0

# Życie i pasek życia
var health: float = 100.0
@onready var progress_bar: ProgressBar = $ProgressBar

# Teleport po śmierci
var teleport = preload("res://Main/teleport.tscn")

func _ready() -> void:
	# Skalowanie trudności
	health += health * 0.2 * (Global.Runda - 1)
	rotation -= global_rotation

	# Ustawienia animacji i paska życia
	$AnimatedSprite2D.play("Idle")
	progress_bar.max_value = health
	progress_bar.value = health

	# Ustaw timer cooldownu
	cooldown_timer.wait_time = cooldown_waittime

func _process(delta: float) -> void:
	progress_bar.value = health
	if health <= 0:
		_on_death()

	# Przygotuj spawner do ataku
	if x == 3:
		bullet_spawn.rotation += deg_to_rad(0.3)
	else:
		bullet_spawn.look_at(Player.global_position)

	# Wykonanie ataku
	if another_atak:
		match(x):
			1:
				atak_timer.wait_time = 1.0
				_circle_attack()
			2:
				atak_timer.wait_time = 0.05
				_spray_attack()
			3:
				atak_timer.wait_time = 0.05
				_eryk_attack()

# Generowanie rodzaju ataku (1..y)
func _generate_attack(y: int) -> int:
	randomize()
	return randi_range(1, y)

# Circle Attack
func _circle_attack() -> void:
	for i in range(20):
		var bullet = bullet_path.instantiate()
		main.add_child(bullet)
		bullet.global_transform = bullet_spawn.global_transform
		bullet.rotation = deg_to_rad(18 * i)
		bullet.speed = 200
		bullet.move_side = true
		bullet.change_timer = true
		bullet.directon = randi_range(1, 2) == 1
		bullet.scale = Vector2(5, 5)
	atak_timer.start()
	another_atak = false
	lasting_timer.wait_time = 10.0
	lasting_timer.start()

# Spray Attack
func _spray_attack() -> void:
	var bullet = bullet_path.instantiate()
	main.add_child(bullet)
	bullet.global_transform = bullet_spawn.global_transform
	bullet.rotation = bullet_spawn.rotation + deg_to_rad(randi_range(-180, 180))
	bullet.speed = 200
	bullet.move_side = false
	bullet.scale = Vector2(2, 2)
	atak_timer.start()
	another_atak = false
	lasting_timer.wait_time = 8.5
	lasting_timer.start()

# Eryk Attack
func _eryk_attack() -> void:
	for i in range(4):
		var bullet = bullet_path.instantiate()
		main.add_child(bullet)
		bullet.global_transform = bullet_spawn.global_transform
		bullet.rotation = bullet_spawn.rotation + deg_to_rad(90 * (i + 1))
		bullet.speed = 200
		bullet.move_side = true
		bullet.change_timer = false
		bullet.directon = true
		bullet.scale = Vector2(3, 3)
	atak_timer.start()
	another_atak = false
	lasting_timer.wait_time = 10.0
	lasting_timer.start()

# Po zakończeniu okresu trwania ataku (ready for next)
func _on_Lasting_Timer_timeout() -> void:
	# Zwolnienie kolejnego ataku i czyszczenie pocisków
	another_atak = true
	for bullet in get_tree().get_nodes_in_group("Boss_Bullet"):
		bullet.queue_free()
	# Uruchom cooldown
	cooldown_timer.start()
	$AnimatedSprite2D.play("Idle")

# Po zakończeniu cooldownu wybierz nowy atak
func _on_Cooldown_Timer_timeout() -> void:
	x = _generate_attack(3)

func _on_Atak_Timer_timeout() -> void:
	pass

# Funkcja uderzenia bossa (wołać zawsze, gdy boss jest trafiony)
func hit(dmg: float) -> void:
	health -= dmg

func _on_death() -> void:
	# Nagroda i teleport
	Global.VDolce += 20
	var teleportacja = teleport.instantiate()
	main.add_child(teleportacja)
	teleportacja.global_position = global_position
	Player.get_node("Node2D/Camera2D").screen_shake(13, 4)
	queue_free()
