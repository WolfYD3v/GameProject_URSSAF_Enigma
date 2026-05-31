extends Control
class_name MyWordle

@onready var cases_node: HBoxContainer = $Control/MarginContainer/Nodes/Cases
@onready var win_audio_stream_player: AudioStreamPlayer = $WinAudioStreamPlayer
@onready var diego_texture_rect: TextureRect = $DiegoTextureRect
@onready var diego: StaticBody3D = $DiegoSubViewport/Diego
@onready var answer_audio_stream_player: AudioStreamPlayer = $AnswerAudioStreamPlayer
@onready var yay_audio_stream_player: AudioStreamPlayer = $YayAudioStreamPlayer
@onready var win_video_stream_player: VideoStreamPlayer = $WinVideoStreamPlayer

var yay_sfxs: Array[AudioStream] = [
	load("res://assets/sfxs/my_wordle_win_yay_sfx_1.mp3"),
	load("res://assets/sfxs/my_wordle_win_yay_sfx_2.mp3")
]
var cases = []
var case_idx: int = 0
var max_case_idx: int = 19
var current_case: MyWordleCase = null
var allowed_characters: String = Cryptographer.alphabetic_characters_list.to_upper()

var allow_inputs: bool = true
var answer_correct_full: bool = true

#var _diego_clicks: int = 0

func _ready() -> void:
	diego_texture_rect.hide()
	SecretCodeManager.wordle_two_text = "AAAAAAAAAAAAAAAAAAAA"
	
	cases = cases_node.get_children()
	reset_case()

func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if diego_texture_rect.visible and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#_diego_clicks = clampi(_diego_clicks + 1, 0, 15)
			#if _diego_clicks >= 15:
				#get_tree().paused = true
				#$AudioStreamPlayer.play()
				#await $AudioStreamPlayer.finished
				#get_tree().paused = false
	
	if not allow_inputs: return
	
	if event is InputEventKey and not event.pressed:
		if event.as_text() in allowed_characters:
			current_case.character = event.as_text()
			increment_case()
			
			if case_idx > max_case_idx:
				allow_inputs = false
				await check_answer()
				await get_tree().create_timer(2.5).timeout
				if answer_correct_full: win_sequence()
				else:
					clear_cases()
					allow_inputs = true

func set_current_case() -> void:
	if cases.is_empty() or case_idx < 0 or case_idx > max_case_idx:
		current_case = cases[0]
	else: current_case = cases[case_idx]

func check_answer() -> void:
	reset_case()
	for case: MyWordleCase in cases:
		case.character_right = case.character == SecretCodeManager.wordle_two_text[case_idx]
		#if case.character == "A": case.character_right = true
		answer_correct_full = case.character_right
		if answer_correct_full: answer_audio_stream_player.stream = load("res://assets/sfxs/box_cat_right_choice_sfx.mp3")
		else: answer_audio_stream_player.stream = load("res://assets/sfxs/box_cat_wrong_choice_sfx.mp3")
		answer_audio_stream_player.play()
		case.show_character_rightness()
		increment_case()
		await get_tree().create_timer(0.2).timeout

func clear_cases() -> void:
	for case: MyWordleCase in cases:
		case.character = case.empty_character
		case.color = case.normal_character_color
	reset_case()

func reset_case() -> void:
	case_idx = 0
	set_current_case()

func increment_case() -> void:
	case_idx += 1
	set_current_case()

func win_sequence() -> void:
	$AmbianceAudioStreamPlayer.stop()
	yay_audio_stream_player.stream = yay_sfxs.pick_random()
	yay_audio_stream_player.play()
	win_video_stream_player.play()
	await yay_audio_stream_player.finished
	win_audio_stream_player.stop()
	await get_tree().create_timer(1.5).timeout
	
	win_audio_stream_player.play()
	diego_texture_rect.show()
	
	for loop in range(75):
		diego.rotate_x(deg_to_rad(randf_range(-50.0, 50.0)))
		diego.rotate_y(deg_to_rad(randf_range(-65.0, 65.0)))
		diego.rotate_z(deg_to_rad(randf_range(-50.0, 50.0)))
		await get_tree().create_timer(0.05).timeout
	queue_free()
