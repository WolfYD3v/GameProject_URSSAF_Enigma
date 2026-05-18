extends StaticBody3D
class_name Diego

@onready var voice_audio_stream_player_3d: AudioStreamPlayer3D = $VoiceAudioStreamPlayer3D
@onready var diego_dialog_box: DiegoDialogBox = $GUI/DiegoDialogBox
@onready var explosion_video_stream_player: VideoStreamPlayer = $ExplosionSubViewport/ExplosionVideoStreamPlayer
@onready var explosion_audio_stream_player_3d: AudioStreamPlayer3D = $ExplosionAudioStreamPlayer3D
@onready var file_tool: FileTool = $FileTool

@export var talk: bool = false:
	set(value):
		talk = value
		if value: start_talk()
		else: stop_talk()
@export var auto_talk: bool = false
@export var talk_paused: bool = false:
	set(value):
		talk_paused = value
		set_paused_talk(value)

func _ready() -> void:
	explosion_video_stream_player.hide()
	diego_dialog_box.new_line.connect(
		func(_line_content: String): turn_around()
	)
	
	if auto_talk: start_talk()

func start_talk() -> void:
	talk_paused = false
	if voice_audio_stream_player_3d:
		voice_audio_stream_player_3d.play()
		diego_dialog_box.play_dialog("res://dialogs/diego_first.json")

func set_paused_talk(value: bool) -> void:
	if voice_audio_stream_player_3d:
		voice_audio_stream_player_3d.stream_paused = value

func stop_talk() -> void:
	if voice_audio_stream_player_3d:
		voice_audio_stream_player_3d.stop()

func turn_around() -> void:
	var rdm_direction: int = randi_range(0, 1)
	if rdm_direction <= 0: rdm_direction = -1
	
	rotate_y(
		deg_to_rad(15.0 * rdm_direction)
	)

func explode() -> void:
	explosion_video_stream_player.show()
	explosion_video_stream_player.play()
	explosion_audio_stream_player_3d.play()
	await explosion_video_stream_player.finished
	explosion_video_stream_player.hide()
	await get_tree().create_timer(1.0).timeout
	await _download_my_file()
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _download_my_file() -> void:
	var file_content: String = "%d" % SecretCodeManager.diego_rdm_number
	if Cryptographer._seleted_cryptography_methods.has("cesar"):
		file_content += "\ncesar"
	file_tool.download_file("diego.txt", file_content, true)
	await file_tool.confirmed
