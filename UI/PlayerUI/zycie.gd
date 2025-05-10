extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer

@export var Player: CharacterBody2D

var health_path = preload("res://UI/PlayerUI/pojedyncze_zycie.tscn")
var magiczne_zycie_path = preload("res://UI/PlayerUI/magiczne_zycie.tscn")
var magiczne_zycie
var can_spawn: bool = true

var start_magiczny_timer: bool
var timer: float

var dictionary1 = {}
var dictionary2 = {}

func _ready() -> void:
	for i in Global.Max_Zycie:
		Spawn_Health(i + 1)
	
func _process(delta: float) -> void:
	#Spawnuje to życko nowe
	if can_spawn == true and Player.Regenerating_Heart == true:
		can_spawn = false
		Spawn_Magiczne_Zycie()
	
	#Sprawdza czy masz dodatkowe zycie jak tak to value = 1
	if Player.Regenerating_Heart == true:
		if Player.Dodatkowe_Zycie == true:
			magiczne_zycie.value = 1
		else:
			start_magiczny_timer = true
			magiczne_zycie.value = 0
	
	#timer do regeneracji
	if start_magiczny_timer == true:
		timer += delta
	if timer >= 10:
		timer = 0
		start_magiczny_timer = false
		Player.Dodatkowe_Zycie = true
	
	for i in range(0,Global.Max_Zycie):
		if dictionary1.get("health" + str(i + 1)) <= Global.Zycie:
			dictionary2.get("health_" + str(i + 1)).value = 1
			
		if dictionary1.get("health" + str(i + 1)) > Global.Zycie:
			dictionary2.get("health_" + str(i + 1)).value = 0

func Spawn_Health(i):
	var health = health_path.instantiate()
	h_box_container.add_child(health)
	dictionary1["health" + str(i)] = i
	dictionary2["health_" + str(i)] = health
	health.max_value = 1
	health.scale = Vector2(18,18)

func Remove_Max_Health(i):
	dictionary1.erase("health" + str(i))
	dictionary2.erase("health_" + str(i))
	
func Spawn_Magiczne_Zycie():
	magiczne_zycie = magiczne_zycie_path.instantiate()
	add_child(magiczne_zycie)
	magiczne_zycie.max_value = 1
	magiczne_zycie.value = 1
