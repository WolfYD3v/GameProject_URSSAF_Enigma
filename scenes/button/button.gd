extends StaticBody3D
class_name Button3D

signal pressed

@onready var button: MeshInstance3D = $Button
@onready var control_indication: MeshInstance3D = $ControlIndication
@onready var pressed_audio_stream_player_3d: AudioStreamPlayer3D = $PressedAudioStreamPlayer3D

@export var one_press: bool = false

var press_count: int = 0
var player_detected: bool = false:
	set(value):
		player_detected = value
		set_control_indication_visibility()
var pressing: bool = false
var tween
var saved_button_position: Vector3

func _ready() -> void:
	control_indication.hide()
	saved_button_position = button.position

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_interact") and not pressing:
		if can_be_pressed() and player_detected: _press()

func can_be_pressed() -> bool:
	if one_press : return press_count < 1
	return true

func set_control_indication_visibility() -> void:
	control_indication.visible = player_detected
	if one_press and press_count > 0: control_indication.hide()

func _press() -> void:
	pressed.emit()
	pressing = true
	press_count += 1
	control_indication.hide()
	
	var lower_val: float = 0.02
	
	pressed_audio_stream_player_3d.play()
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		button, "position",
		Vector3(
			button.position.x, button.position.y - lower_val,
			button.position.z - lower_val
		), 0.4
	)
	tween.tween_property(
		button, "position",
		saved_button_position, 0.3
	).set_delay(0.45)
	
	await tween.finished
	pressing = false
	set_control_indication_visibility()

func _on_player_detection_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player_detected = not(body.is_crouching)

func _on_player_detection_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		player_detected = false
