extends Node

@onready var menu_button_down: AudioStreamPlayer = $MenuButtonDown
@onready var menu_button_up: AudioStreamPlayer = $MenuButtonUp
@onready var buy_1: AudioStreamPlayer = $Buy1
@onready var buy_2: AudioStreamPlayer = $Buy2

@onready var main_menu: AudioStreamPlayer = $music/MainMenu

@onready var battle_tracks: Array[AudioStreamPlayer] = [
	$"music/02-NuclearFusion",
	$"music/03-LunarClockLunaDial(feat_JamesFraser)",
	$"music/04-LunaticPrincess",
	$"music/05-FloweringNight",
	$"music/06-NativeFaith",
	$"music/07-SeptetteForTheDeadPrincess(feat_JonathanParecki)",
	$"music/08-ReachForTheMoon,ImmortalSmoke(feat_AlejandroHernández)",
	$"music/09-BelovedTomboyishDaughter",
	$"music/11-LoveColouredMasterSpark",
	$"music/12-PrimoridalBeat(feat_JerodCollins)",
	$"music/13-BorderOfLife"
]

@onready var shop_and_dungeons_tracks: Array[AudioStreamPlayer] = [
	$"music/05-FloweringNight",
	$"music/10-Necrofantasia"
]

# Location -> track(s)
var location_tracks := {
	"shop_and_dungeons": shop_and_dungeons_tracks,
	"arena": battle_tracks,
	"boss_room": $"music/01-U_n_OwenWasHer"
}

var current_track: AudioStreamPlayer = null
var last_battle_track: AudioStreamPlayer = null
var track_positions: Dictionary = {}

# --- FADING FUNCTIONS ---

func crossfade_tracks(old_track: AudioStreamPlayer, new_track: AudioStreamPlayer, duration: float, target_db: float = 0.0) -> void:
	if new_track == old_track:
		return

	if new_track:
		new_track.volume_db = -40.0
		new_track.stream.loop = true
		if track_positions.has(new_track):
			new_track.play(track_positions[new_track])
		else:
			new_track.play()

	var time_passed := 0.0
	var start_db := old_track.volume_db if old_track else 0.0

	while time_passed < duration:
		await get_tree().process_frame
		var delta = get_process_delta_time()
		time_passed += delta
		var t = time_passed / duration

		if old_track:
			old_track.volume_db = lerp(start_db, -40.0, t)
		if new_track:
			new_track.volume_db = lerp(-40.0, target_db, t)

	if old_track:
		track_positions[old_track] = old_track.get_playback_position()
		old_track.stop()

	if new_track:
		new_track.volume_db = target_db
		current_track = new_track

# --- MUSIC CONTROL ---

func stop_music(duration: float = 1.0) -> void:
	if current_track and current_track.playing:
		await fade_out(current_track, duration)
		current_track = null

func fade_out(track: AudioStreamPlayer, duration: float) -> void:
	var start_db = track.volume_db
	var time_passed := 0.0

	while time_passed < duration:
		await get_tree().process_frame
		var delta = get_process_delta_time()
		time_passed += delta
		track.volume_db = lerp(start_db, -40.0, time_passed / duration)

	track_positions[track] = track.get_playback_position()
	track.stop()

func play_main_menu(volume_db: float = 0.0) -> void:
	if current_track == main_menu and main_menu.playing:
		return
	await crossfade_tracks(current_track, main_menu, 1.0, volume_db)

func play_random_battle_track(volume_db: float = 0.0) -> void:
	var track: AudioStreamPlayer = null
	while true:
		track = battle_tracks[randi() % battle_tracks.size()]
		if track != last_battle_track:
			break

	last_battle_track = track
	await crossfade_tracks(current_track, track, 1.0, volume_db)

func play_music_for_location(location: String, volume_db: float = 0.0) -> void:
	if not location_tracks.has(location):
		push_warning("Unknown location: " + location)
		return

	var music_data = location_tracks[location]

	if music_data is AudioStreamPlayer:
		if current_track == music_data and music_data.playing:
			return
		await crossfade_tracks(current_track, music_data, 1.0, volume_db)

	elif music_data is Array:
		var track: AudioStreamPlayer = null
		while true:
			track = music_data[randi() % music_data.size()]
			if track != last_battle_track:
				break
		last_battle_track = track
		await crossfade_tracks(current_track, track, 1.0, volume_db)
