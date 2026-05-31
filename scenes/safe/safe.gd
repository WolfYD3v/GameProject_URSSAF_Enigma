extends Node3D
class_name Safe

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var control_indication: MeshInstance3D = $ControlIndication
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var line_edit: LineEdit = $CanvasLayer/MarginContainer/LineEdit

var player: Player = null
var input_right: bool = false
var minigame_on: bool = false

func _ready() -> void:
	canvas_layer.hide()
	control_indication.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("player_interact") and player:
			if not player.can_crouch and not minigame_on or line_edit.has_focus(): return
			minigame_on = not(minigame_on)
			canvas_layer.visible = minigame_on
			
			player.can_crouch = not(player.can_crouch)
			player.can_jump = not(player.can_jump)
			player.can_move = not(player.can_move)
			player.can_rotate = not(player.can_rotate)
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_try_open_safe_button_3d_pressed() -> void:
	print("Trying opening safe...")
	if line_edit.text.is_empty(): return
	
	input_right = line_edit.text == SecretCodeManager._encrypted_secret_code
	if input_right:
		control_indication.hide()
		animation_player.play("open")
	else:
		if DenuvoLikeShit.normal_gamemode:
			OS.alert("Vaya, parece que has introducido el código secreto equivocado...\nYa sabes lo que te espera :)", "Diego")
			get_tree().quit()
		else: print("Safe Door - Wrong Encrypted Secret Code Inputed")

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		if not body.is_crouching and not input_right:
			player = body
			control_indication.show()

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		control_indication.hide()
