extends Node3D
class_name MainMenu

@onready var song_audio_stream_player: AudioStreamPlayer = $SongAudioStreamPlayer
@onready var main_menu_2d_interface: MainMenu2DInterface = $GUISubViewport/MainMenu2DInterface

var can_be_freed: bool = false:
	set(value):
		can_be_freed = value
		if value: queue_free()

func _ready() -> void:
	get_tree().paused = true
	setup_song()
	main_menu_2d_interface.animate()

func _input(event: InputEvent) -> void:
	var set_free: bool = false
	
	if event is InputEventKey or event is InputEventMouseButton:
		get_tree().paused = false
		set_free = randi_range(1, 50) != 37
		if set_free: can_be_freed = true
	if event is InputEventKey and not set_free: can_be_freed = true

func setup_song() -> void:
	var random_chance: int = randi_range(1, 20)
	
	if random_chance >= 18:
		song_audio_stream_player.pitch_scale = 2.5
		main_menu_2d_interface.animation_scale = 7.5
	song_audio_stream_player.play()
