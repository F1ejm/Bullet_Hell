extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer

var health_path = preload("res://UI/PlayerUI/pojedyncze_zycie.tscn")

var dictionary1 = {}
var dictionary2 = {}

func _ready() -> void:
	for i in Global.Max_Zycie:
		Spawn_Health(i + 1)
	
func _process(delta: float) -> void:
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
