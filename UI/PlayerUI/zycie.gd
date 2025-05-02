extends Control

@onready var texture_progress_bar: TextureProgressBar = $HBoxContainer/TextureProgressBar
@onready var texture_progress_bar_2: TextureProgressBar = $HBoxContainer/TextureProgressBar2
@onready var texture_progress_bar_3: TextureProgressBar = $HBoxContainer/TextureProgressBar3
@onready var texture_progress_bar_4: TextureProgressBar = $HBoxContainer/TextureProgressBar4
@onready var texture_progress_bar_5: TextureProgressBar = $HBoxContainer/TextureProgressBar5
@onready var texture_progress_bar_6: TextureProgressBar = $HBoxContainer/TextureProgressBar6

func _ready() -> void:
	texture_progress_bar.max_value = 1
	texture_progress_bar_2.max_value = 1
	texture_progress_bar_3.max_value = 1
	texture_progress_bar_4.max_value = 1
	texture_progress_bar_5.max_value = 1
	texture_progress_bar_6.max_value = 1

func _process(delta: float) -> void:
	texture_progress_bar.value = Global.Zycie
	texture_progress_bar_2.value = Global.Zycie - 1
	texture_progress_bar_3.value = Global.Zycie - 2
	texture_progress_bar_4.value = Global.Zycie - 3
	texture_progress_bar_5.value = Global.Zycie - 4
	texture_progress_bar_6.value = Global.Zycie - 5
