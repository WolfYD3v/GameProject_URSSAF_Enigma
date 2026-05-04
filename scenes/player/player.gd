extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = $Camera
@onready var walk_audio_stream_player_3d: AudioStreamPlayer3D = $WalkAudioStreamPlayer3D

@export_range(0.001, 0.002, 0.001, "hide_control", "or_greater") var mouse_sensitivity: float = 0.002
@export_range(1.2, 1.3, 0.05, "hide_control", "or_greater") var crouch_speed: float = 1.2
@export_range(3.5, 3.6, 0.05, "hide_control", "or_greater") var walk_speed: float = 3.5
@export_range(5.0, 5.1, 0.05, "hide_control", "or_greater") var run_speed: float = 5.0
@export_range(1.0, 1.1, 0.05, "hide_control", "or_greater") var jump_velocity: float = 1.0

var speed: float = 1.0
var accel: float = 1.0
var direction: Vector3
var max_camera_x_rotation: float = deg_to_rad(50.0)

var is_jumping: bool = false
var is_crouching: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion: handle_rotation(event)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	if is_on_floor(): is_jumping = false
	set_speed()
	
	handle_crouch()
	handle_jump()
	handle_mouvement()
	handle_walk_sound()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_crouch() -> void:
	if not is_on_floor(): return
	if Input.is_action_just_pressed("player_crouch_toggle"):
		is_crouching = not(is_crouching)
		
		if is_crouching: scale = Vector3(
			0.6, 0.6, 0.6
		)
		else: scale = Vector3(
			1.0, 1.0, 1.0
		)

func handle_rotation(event: InputEvent) -> void:
	rotate_y(-event.relative.x * mouse_sensitivity * accel)
	camera.rotate_x(-event.relative.y * mouse_sensitivity * accel)
	
	camera.rotation.x = clampf(
		camera.rotation.x, -max_camera_x_rotation,
		max_camera_x_rotation
	)

func set_accel() -> void:
	if direction and Input.is_action_pressed("player_run_toggle") and not is_crouching:
		accel = clampf(accel + 0.01, 1.0, 1.3)
	else: accel = 1.0

func set_speed() -> void:
	speed = walk_speed
	if Input.is_action_pressed("player_run_toggle"): speed = run_speed
	if is_crouching: speed = crouch_speed
	
	set_accel()
	speed *= accel

func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_crouching:
		walk_audio_stream_player_3d.stop()
		is_jumping = true
		velocity.y = jump_velocity * speed

func handle_mouvement() -> void:
	var input_dir := Input.get_vector(
		"player_right", "player_left",
		"player_up", "player_down"
	)
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		walk_audio_stream_player_3d.stop()
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func handle_walk_sound() -> void:
	if walk_audio_stream_player_3d.playing or is_jumping or is_crouching: return
	if direction:
		walk_audio_stream_player_3d.pitch_scale = randf_range(
			0.90 * accel,
			1.10 * accel
		)
		walk_audio_stream_player_3d.play()
