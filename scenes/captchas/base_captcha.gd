extends Control
class_name BaseCaptcha

@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var check_answer_button: Button = $Control/MarginContainer/VBoxContainer/CheckAnswerButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var control: Control = $Control
@onready var animation: Control = $Animation
@onready var music_audio_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer

var answer: String = "":
	set(value):
		answer = value
		check_answer_button.disabled = answer.length() != answer_max_lenght
var answer_max_lenght: int = 7
var check_answer_waiting_time: float = 0.5

func _ready() -> void:
	play_opening_anim()

func play_opening_anim() -> void:
	control.hide()
	check_answer_button.disabled = true
	play_sfx("res://assets/sfxs/captcha_minigame_sfx.mp3")
	animation_player.play("Anims/opening")
	await animation_player.animation_finished
	await get_tree().create_timer(2.5).timeout
	play_sfx("res://assets/sfxs/pop_sfx.mp3")
	play_ambiance()
	animation.hide()
	control.show()
	check_answer_button.disabled = false
	answer = ""

func play_sfx(sfx_path: String) -> void:
	if FileAccess.file_exists(sfx_path):
		sfx_audio_stream_player.stop()
		sfx_audio_stream_player.stream = load(sfx_path)
		sfx_audio_stream_player.play()

func play_ambiance() -> void:
	music_audio_stream_player.volume_db = randf_range(0.0, 5.0)
	music_audio_stream_player.pitch_scale = randf_range(1.0, 1.1)
	if not music_audio_stream_player.playing:
		music_audio_stream_player.play()

func answer_right() -> void:
	OS.alert("Humanity verified !" , " ")
	queue_free()

func answer_wrong() -> void:
	check_answer_button.disabled = false

func _on_check_answer_button_pressed() -> void:
	check_answer_button.disabled = true
	await get_tree().create_timer(check_answer_waiting_time).timeout
	
	if answer == CaptchatsData.right_answer: answer_right()
	else: answer_wrong()
