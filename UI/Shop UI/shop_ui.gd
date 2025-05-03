extends Control

@onready var health_button: Button = $HBoxContainer/Health/Health_Button
@onready var stamina_button: Button = $"HBoxContainer/Stamina Amount/Stamina_Button"
@onready var stamina_regen_button: Button = $"HBoxContainer/Stamina Regen/Stamina_Regen_Button"
@onready var attack_speed_button: Button = $HBoxContainer/Attack/Attack_Speed_Button

@onready var Stamina_Bar: ProgressBar = $"HBoxContainer/Stamina Amount/ProgressBar"
@onready var Health_Bar: ProgressBar = $HBoxContainer/Health/ProgressBar
@onready var Regen_Bar: ProgressBar = $"HBoxContainer/Stamina Regen/ProgressBar"
@onready var Attack_Bar: ProgressBar = $HBoxContainer/Attack/ProgressBar

func _ready() -> void:
	Stamina_Bar.max_value = 3
	Stamina_Bar.value = 0
	Health_Bar.max_value = 3
	Health_Bar.value = 0
	Regen_Bar.max_value = 3
	Regen_Bar.value = 0
	Attack_Bar.max_value = 3
	Attack_Bar.value = 0
	visible = false

func _process(delta: float) -> void:
	if Global.shop_ui_visible == true:
		visible = true
	else:
		visible = false

#Pieniądze Trzeba TODO
func _on_health_button_pressed() -> void:
	if Global.Max_Zycie < 6:
		Global.Zycie += 1
		Global.Max_Zycie += 1
		Health_Bar.value += 1
	

func _on_stamina_button_pressed() -> void:
	if Global.Max_Stamina < 350:
		Global.Stamina += 50
		Global.Max_Stamina += 50
		Stamina_Bar.value += 1


func _on_stamina_regen_button_pressed() -> void:
	if Global.Stamina_Regen < 1.6:
		Global.Stamina_Regen += 0.2
		Regen_Bar.value += 1


func _on_attack_speed_button_pressed() -> void:
	if Global.AtakCooldown > 1.05:
		Global.AtakCooldown -= 0.35
		Attack_Bar.value += 1
