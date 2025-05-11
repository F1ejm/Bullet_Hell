extends Node

@onready var menu_button_down: AudioStreamPlayer = $MenuButtonDown
@onready var menu_button_up: AudioStreamPlayer = $MenuButtonUp
@onready var buy_1: AudioStreamPlayer = $Buy1
@onready var buy_2: AudioStreamPlayer = $Buy2

@onready var main_menu: AudioStreamPlayer = $music/MainMenu

@onready var battle_tracks: Array[AudioStreamPlayer] = [
	$"music/01-U_n_OwenWasHer",
	$"music/02-NuclearFusion",
	$"music/03-LunarClockLunaDial(feat_JamesFraser)",
	$"music/04-LunaticPrincess",
	$"music/05-FloweringNight",
	$"music/06-NativeFaith",
	$"music/07-SeptetteForTheDeadPrincess(feat_JonathanParecki)",
	$"music/08-ReachForTheMoon,ImmortalSmoke(feat_AlejandroHernández)",
	$"music/09-BelovedTomboyishDaughter",
	$"music/10-Necrofantasia",
	$"music/11-LoveColouredMasterSpark",
	$"music/12-PrimoridalBeat(feat_JerodCollins)",
	$"music/13-BorderOfLife"
]

var current_track: AudioStreamPlayer = null
var last_battle_track: AudioStreamPlayer = null

# --- FADING FUNCTIONS ---

func fade_out(audio: AudioStreamPlayer, duration: float) -> void:
	if not audio or not audio.playing:
		return

	var start_db = audio.volume_db
	var target_db = -40.0
	var time_passed := 0.0

	while time_passed < duration and audio.volume_db > target_db:
		await get_tree().process_frame
		var delta = get_process_delta_time()
		time_passed += delta
		audio.volume_db = lerp(start_db, target_db, time_passed / duration)

	audio.stop()

func fade_in(audio: AudioStreamPlayer, duration: float, target_db: float = 0.0) -> void:
	if not audio:
		return

	audio.volume_db = -40.0
	audio.play()
	var time_passed := 0.0

	while time_passed < duration and audio.volume_db < target_db:
		await get_tree().process_frame
		var delta = get_process_delta_time()
		time_passed += delta
		audio.volume_db = lerp(-40.0, target_db, time_passed / duration)

	audio.volume_db = target_db

# --- MUSIC CONTROL ---

func play_main_menu(volume_db: float = 0.0) -> void:
	if current_track == main_menu and main_menu.playing:
		return # Already playing

	if current_track and current_track != main_menu:
		await fade_out(current_track, 1.0)

	main_menu.stream.loop = true
	current_track = main_menu
	await fade_in(main_menu, 1.0, volume_db)

func play_random_battle_track(volume_db: float = 0.0) -> void:
	if current_track and current_track.playing:
		await fade_out(current_track, 1.0)

	# Pick a track that is not the same as last time
	var track: AudioStreamPlayer = null
	while true:
		track = battle_tracks[randi() % battle_tracks.size()]
		if track != last_battle_track:
			break

	track.stream.loop = true
	last_battle_track = track
	current_track = track
	await fade_in(track, 1.0, volume_db)
