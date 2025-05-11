extends Control

@onready var health_button: TextureButton = $HBoxContainer/Health/Health_Button
@onready var stamina_button: TextureButton = $"HBoxContainer/Stamina Amount/Stamina_Button"
@onready var stamina_regen_button: TextureButton = $"HBoxContainer/Stamina Regen/Stamina_Regen_Button"
@onready var attack_speed_button: TextureButton = $HBoxContainer/Attack/Attack_Speed_Button

@onready var Stamina_Bar: TextureProgressBar = $"HBoxContainer/Stamina Amount/ProgressBar"
@onready var Health_Bar: TextureProgressBar = $HBoxContainer/Health/ProgressBar
@onready var Regen_Bar: TextureProgressBar = $"HBoxContainer/Stamina Regen/ProgressBar"
@onready var Attack_Bar: TextureProgressBar = $HBoxContainer/Attack/ProgressBar

@onready var texture_rect_health: TextureRect = $HBoxContainer/Health/TextureRect
@onready var texture_rect_stamina: TextureRect = $"HBoxContainer/Stamina Amount/TextureRect"
@onready var texture_rect_atak: TextureRect = $HBoxContainer/Attack/TextureRect
@onready var texture_rect_regen: TextureRect = $"HBoxContainer/Stamina Regen/TextureRect"


@export var Zycie_UI: Control

var health_cost: int = 5
var stamina_cost: int = 5
var regen_cost: int = 5
var atak_cost: int = 5

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
	
	
	
	if Global.VDolce < health_cost and Health_Bar.value != 3:
		health_button.tooltip_text = "Not enough money"
		health_button.disabled = true
	elif Health_Bar.value != 3 and Global.VDolce > health_cost:
		health_button.tooltip_text = str(health_cost) + " $"
	elif Health_Bar.value == 3:
		health_button.tooltip_text = ""
	else:
		health_button.disabled = false
	
	if Global.VDolce < regen_cost and Regen_Bar.value != 3:
		stamina_regen_button.tooltip_text = "Not enough money"
		stamina_regen_button.disabled = true
	elif Regen_Bar.value != 3 and Global.VDolce > regen_cost:
		stamina_regen_button.tooltip_text = str(regen_cost) + " $"
	elif Regen_Bar.value == 3:
		stamina_regen_button.tooltip_text = ""
	else:
		stamina_regen_button.disabled = false
	
	if Global.VDolce < stamina_cost and Stamina_Bar.value != 3:
		stamina_button.tooltip_text = "Not enough money"
		stamina_button.disabled = true
	elif Stamina_Bar.value != 3 and Global.VDolce > stamina_cost:
		stamina_button.tooltip_text = str(stamina_cost) + " $"
	elif Stamina_Bar.value == 3:
		stamina_button.tooltip_text = ""
	else:
		stamina_button.disabled = false
	
	if Global.VDolce < atak_cost and Attack_Bar.value != 3:
		attack_speed_button.tooltip_text = "Not enough money"
		attack_speed_button.disabled = true
	elif Attack_Bar.value != 3 and Global.VDolce > atak_cost:
		attack_speed_button.tooltip_text = str(atak_cost) + " $"
	elif Attack_Bar.value == 3:
		attack_speed_button.tooltip_text = ""
	else:
		attack_speed_button.disabled = false
	

#Pieniądze Trzeba TODO
func _on_health_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Health_Bar.value < 3 and Global.VDolce >= health_cost:
		Global.VDolce -= health_cost
		health_cost = health_cost * 2
		Global.Zycie += 1
		Global.Max_Zycie += 1
		Zycie_UI.Spawn_Health(Global.Max_Zycie)
		Health_Bar.value += 1
	

func _on_stamina_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Stamina_Bar.value < 3 and Global.VDolce >= stamina_cost:
		Global.VDolce -= stamina_cost
		stamina_cost = stamina_cost * 2
		Global.Stamina += 50
		Global.Max_Stamina += 50
		Stamina_Bar.value += 1


func _on_stamina_regen_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Regen_Bar.value < 3 and Global.VDolce >= regen_cost:
		Global.VDolce -= regen_cost
		regen_cost = regen_cost * 2
		Global.Stamina_Regen += 0.2
		Regen_Bar.value += 1


func _on_attack_speed_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Attack_Bar.value < 3 and Global.VDolce >= atak_cost:
		Global.VDolce -= atak_cost
		atak_cost = atak_cost * 2
		Global.RangeCooldown -= 0.35
		Attack_Bar.value += 1
