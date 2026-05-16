extends StaticBody3D
class_name BigDoor

@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2
@onready var sfx_audio_stream_player_3d: AudioStreamPlayer3D = $SFXAudioStreamPlayer3D

var tween

func _ready() -> void:
	pass

func tween_doors() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_parallel(true)
	tween.tween_property(
		marker_3d, "rotation:y",
		deg_to_rad(-90.0), 5.0
	)
	sfx_audio_stream_player_3d.play()
	await tween.finished
	sfx_audio_stream_player_3d.stop()
