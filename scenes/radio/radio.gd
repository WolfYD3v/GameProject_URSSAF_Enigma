extends StaticBody3D
class_name Radio

signal song_finished

enum PLAY_MODES {
	ORDERED,
	RANDOM
}

@export var songs: Array[AudioStream] = []
@export var play_mode: PLAY_MODES = PLAY_MODES.ORDERED
@export var autoplay: bool = true

@onready var song_audio_stream_player_3d: AudioStreamPlayer3D = $SongAudioStreamPlayer3D

var _song_idx: int = 0
var current_song: AudioStream = null

func _ready() -> void:
	song_finished.connect(
		func(): play()
	)
	if autoplay: play()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_RIGHT): play()

func play(is_randomized: bool = false) -> void:
	if is_randomized: play_mode = PLAY_MODES.RANDOM
	if songs.is_empty(): return
	
	stop()
	current_song = _get_song_to_play()
	song_audio_stream_player_3d.stream = current_song
	song_audio_stream_player_3d.play()
	print("%s : Playing '%s'" % [
		name,
		current_song.resource_path.get_file()
	])
	
	await song_audio_stream_player_3d.finished
	song_finished.emit()

func _get_song_to_play() -> AudioStream:
	var song_to_play: AudioStream = null
	
	match play_mode:
		PLAY_MODES.ORDERED:
			song_to_play = songs.get(_song_idx)
			_song_idx += 1
			if _song_idx >= songs.size(): _song_idx = 0
		PLAY_MODES.RANDOM:
			var _songs: Array[AudioStream] = songs.duplicate()
			if current_song: _songs.erase(current_song)
			song_to_play = _songs.pick_random()
	
	return song_to_play

func stop() -> void:
	song_audio_stream_player_3d.stop()
