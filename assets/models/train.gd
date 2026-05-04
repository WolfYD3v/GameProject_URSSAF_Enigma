extends Node3D
class_name Train

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	pass

func play_audio() -> void:
	audio_stream_player_3d.play()

func stop_audio() -> void:
	audio_stream_player_3d.stop()
