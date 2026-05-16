extends StaticBody3D
class_name Radio

signal song_finished

enum PLAY_MODES {
	ORDERED,
	RANDOM
}

@onready var song_audio_stream_player_3d: AudioStreamPlayer3D = $RadioMesh/SongAudioStreamPlayer3D
@onready var button_audio_stream_player_3d: AudioStreamPlayer3D = $RadioMesh/ButtonAudioStreamPlayer3D
@onready var button: MeshInstance3D = $RadioMesh/Button
@onready var control_indication: MeshInstance3D = $RadioMesh/ControlIndication

@export var songs: Array[AudioStream] = []
@export var play_mode: PLAY_MODES = PLAY_MODES.ORDERED
@export var autoplay: bool = false
@export var playing: bool = false:
	set(value):
		playing = value
		if not is_inside_tree(): return
		if playing: play()
		else: stop()
@export var repeat: bool = true

var repeat_count: int = 0
var _song_idx: int = 0
var current_song: AudioStream = null
var player: Player = null:
	set(value):
		player = value
		if not is_inside_tree(): return
		control_indication.visible = player != null and not player.is_crouching

func _ready() -> void:
	control_indication.hide()
	song_finished.connect(
		func(): play()
	)
	if autoplay: play()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("player_interact") and player:
			if not player.is_crouching: playing = not(playing)

func play(is_randomized: bool = false) -> void:
	if is_randomized: play_mode = PLAY_MODES.RANDOM
	if songs.is_empty(): return
	if not repeat and repeat_count >= 1: return
	
	_try_set_repeat_count()
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

func _try_set_repeat_count() -> void:
	if _song_idx + 1 >= songs.size() and play_mode == PLAY_MODES.ORDERED:
		repeat_count += 1

func _get_song_to_play() -> AudioStream:
	var song_to_play: AudioStream = null
	
	match play_mode:
		PLAY_MODES.ORDERED:
			song_to_play = songs.get(_song_idx)
			_song_idx += 1
			_song_idx = clampi(
				_song_idx, 0, songs.size() - 1
			)
		PLAY_MODES.RANDOM:
			var _songs: Array[AudioStream] = songs.duplicate()
			if current_song: _songs.erase(current_song)
			song_to_play = _songs.pick_random()
	
	return song_to_play

func stop() -> void:
	song_audio_stream_player_3d.stop()
	print("%s : Stoped" % [name])


func _on_player_detection_area_3d_body_entered(body: Node3D) -> void:
	if body is Player: player = body

func _on_player_detection_area_3d_body_exited(body: Node3D) -> void:
	if body is Player: player = null
