extends Control

@onready var resolution_button: OptionButton = $MarginContainer3/VBoxContainer2/HBoxContainer/resolutions
@onready var fullscreen_button: OptionButton = $MarginContainer3/VBoxContainer2/HBoxContainer2/fullscreen
@onready var master_volume: HSlider = $"MarginContainer2/VBoxContainer/Master Volume"
@onready var music_volume: HSlider = $"MarginContainer2/VBoxContainer/Music Volume"
@onready var sfx_volume: HSlider = $"MarginContainer2/VBoxContainer/SFX Volume"


func _process(delta: float) -> void:
	if Global.is_in_settings == true:
		visible = true
	else:
		visible = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and Global.is_in_settings == true:
		Global.is_in_settings = false
		call_deferred("_return_to_pause_menu")

func _ready():
	for res in resolutions:
		resolution_button.add_item(res)
		
	resolution_button.selected = Global.current_resolution_id
	fullscreen_button.selected = Global.current_fullscreen_mode
	
	master_volume.value = Global.current_master_volume
	music_volume.value = Global.current_music_volume
	sfx_volume.value = Global.current_sfx_volume


var resolutions := [
	"1920 x 1080",
	"1600 x 900",
	"1366 x 768",
	"1280 x 720",
	"2560 x 1440",
	"3840 x 2160",
	"1024 x 768",
	"800 x 600",
	"2560 x 1080",  # Ultrawide
	"3440 x 1440"   # Ultrawide
]


# Resolution selection
func _on_resolutions_item_selected(index: int) -> void:
	Global.current_resolution_id = index
	var split = resolutions[index].split(" x ")
	var new_resolution = Vector2i(split[0].to_int(), split[1].to_int())
	Global.current_resolution = new_resolution
	DisplayServer.window_set_size(new_resolution)
	
# Fullscreen selection
func _on_fullscreen_item_selected(index: int) -> void:
	Global.current_fullscreen_mode = index
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


# Audio ------------------------------------------------------------------
func _on_master_volume_value_changed(value: float) -> void:
	Global.current_master_volume = value
	AudioServer.set_bus_volume_linear(0, value)

func _on_music_volume_value_changed(value: float) -> void:
	Global.current_music_volume = value
	AudioServer.set_bus_volume_linear(1, value)

func _on_sfx_volume_value_changed(value: float) -> void:
	Global.current_sfx_volume = value
	AudioServer.set_bus_volume_linear(2, value)

func _on_back_pressed() -> void:
	Global.is_in_settings = false
	call_deferred("_return_to_pause_menu")

func _return_to_pause_menu():
	Global.is_in_pause_menu = true
