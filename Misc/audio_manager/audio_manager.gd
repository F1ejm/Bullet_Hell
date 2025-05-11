extends Node

@onready var menu_button_down: AudioStreamPlayer = $MenuButtonDown
@onready var menu_button_up: AudioStreamPlayer = $MenuButtonUp
@onready var buy_1: AudioStreamPlayer = $Buy1
@onready var buy_2: AudioStreamPlayer = $Buy2

@onready var main_menu: AudioStreamPlayer = $music/MainMenu


func fade_out(audio: AudioStreamPlayer, duration: float) -> void:
	var initial_volume = audio.volume_linear
	var time_passed := 0.0

	while time_passed < duration and audio.volume_linear > 0.0:
		await get_tree().process_frame
		var delta = get_process_delta_time()
		time_passed += delta
		audio.volume_linear = lerp(initial_volume, 0.0, time_passed / duration)

	audio.volume_linear = 0.0
	audio.stop()


func play_main_menu(volume: float):
	if main_menu.playing:
		return
	main_menu.play()
	main_menu.volume_db = volume
