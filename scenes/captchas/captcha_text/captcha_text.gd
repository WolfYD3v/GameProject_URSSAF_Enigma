extends BaseCaptcha
class_name CaptchaText

@onready var image_texture_rect: TextureRect = $Control/MarginContainer/VBoxContainer/ImageTextureRect
@onready var answer_line_edit: LineEdit = $Control/MarginContainer/VBoxContainer/AnswerLineEdit
@onready var attemps_progress_bar: ProgressBar = $Control/AttempsProgressBar
@onready var ohhh_audio_stream_player: AudioStreamPlayer = $OhhhAudioStreamPlayer

var random_image_rotation_value: float = 0.0
var attemps: int = 1
var max_attemps: int = 10

func _ready() -> void:
	play_opening_anim()
	
	ohhh_audio_stream_player.pitch_scale = 1.0
	init_attemps()
	init_image()

func init_attemps() -> void:
	attemps = 1
	attemps_progress_bar.max_value = float(max_attemps)
	attemps_progress_bar.value = float(max_attemps)

func init_image() -> void:
	random_image_rotation_value = randf_range(0.05, 2.50)
	if randi_range(0, 1) == 1: random_image_rotation_value = -random_image_rotation_value
	image_texture_rect.pivot_offset_ratio = Vector2(0.5, 0.5)
	
	var picked_image_path: String = CaptchatsData.captchat_image_answer_associations.find_key(CaptchatsData.right_answer)
	image_texture_rect.texture = load(picked_image_path)
	image_texture_rect.flip_h = bool(randi_range(0, 1))
	image_texture_rect.flip_v = bool(randi_range(0, 1))
	image_texture_rect.modulate = Color(0.02, 0.02, 0.02, 1.0)

func answer_wrong() -> void:
	check_answer_button.disabled = false
	answer_line_edit.editable = true
	answer_line_edit.text = ""
	image_texture_rect.modulate += Color(0.008, 0.008, 0.008, 1.0)
	ohhh_audio_stream_player.play()
	attemps = clampi(attemps + 1, 0, max_attemps)
	ohhh_audio_stream_player.pitch_scale += 0.15
	attemps_progress_bar.value -= 1.0
	check_answer_waiting_time += float(attemps) / 5.0
	play_ambiance()

func _process(delta: float) -> void:
	image_texture_rect.rotation += random_image_rotation_value * delta

func _on_check_answer_button_pressed_bis() -> void:
	answer = answer_line_edit.text
	answer_line_edit.editable = false

func _on_answer_line_edit_text_changed(new_text: String) -> void:
	answer = new_text

func _on_attemps_progress_bar_value_changed(value: float) -> void:
	if value <= 0.0:
		ohhh_audio_stream_player.pitch_scale = 1.0
		init_attemps()
		init_image()
