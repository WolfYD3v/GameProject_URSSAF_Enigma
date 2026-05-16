extends StaticBody3D
class_name SchrodingerCat

@onready var buttons: Node3D = $Buttons
@onready var schrodinger_cat_interface: SchrodingerCatInterface = $SubViewport/SchrodingerCatInterface
@onready var control_indication: MeshInstance3D = $ControlIndication
@onready var sfx_audio_stream_player_3d: AudioStreamPlayer3D = $SFXAudioStreamPlayer3D
@onready var timer: Timer = $Timer

enum CAT_STATUS {
	ALIVE,
	MID,
	DEAD
}
var cat_status: CAT_STATUS = CAT_STATUS.ALIVE

var cat_alive: bool = true
var cat_50_50: bool = false

var rounds: int = 1
@export_range(1, 2, 1, "or_greater") var max_rounds: int = 10
var mistakes: int = 5

var player: Player = null
var player_captured: bool = false

var pseudo_konami_code_to_input: Array[CAT_STATUS] = [
	CAT_STATUS.ALIVE, CAT_STATUS.ALIVE, CAT_STATUS.DEAD, CAT_STATUS.DEAD,
	CAT_STATUS.MID, CAT_STATUS.DEAD, CAT_STATUS.MID, CAT_STATUS.DEAD,
	CAT_STATUS.MID, CAT_STATUS.ALIVE
]
var pseudo_konami_code_inputed: Array[CAT_STATUS] = []
var pseudo_konami_code_inputed_idx: int  = 0
var pseudo_konami_code_working: bool = true

func _ready() -> void:
	control_indication.hide()
	init_cat()
	init_buttons()
	schrodinger_cat_interface.init_progress_bar(float(max_rounds))

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("player_interact") and player_captured:
			player_captured = not(player_captured)
			control_indication.hide()
			if player:
				player.can_crouch = not(player.can_crouch)
				player.can_jump = not(player.can_jump)
				player.can_move = not(player.can_move)
			$PlayerDetectionArea/CollisionShape.disabled = not(
				$PlayerDetectionArea/CollisionShape.disabled
			)
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.is_action_just_pressed("player_interact") and player and timer.is_stopped():
			timer.start()
			player_captured = not(player_captured)
			control_indication.hide()
			if player:
				player.can_crouch = not(player.can_crouch)
				player.can_jump = not(player.can_jump)
				player.can_move = not(player.can_move)
			$PlayerDetectionArea/CollisionShape.disabled = not(
				$PlayerDetectionArea/CollisionShape.disabled
			)
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else: pass

func update_pseudo_konami_code(cat_status_to_add: CAT_STATUS) -> void:
	if not pseudo_konami_code_working: return
	
	if cat_status_to_add == pseudo_konami_code_to_input[
		pseudo_konami_code_inputed_idx
	]:
		pseudo_konami_code_inputed.append(cat_status_to_add)
		pseudo_konami_code_inputed_idx += 1
		print("%s - Pseudo Konami Code (Right Input)" % name)
		print("%s - Pseudo Konami Code: %s" % [name, pseudo_konami_code_inputed])
		
		if pseudo_konami_code_to_input == pseudo_konami_code_inputed:
			pseudo_konami_code_working = false
			print("%s - Pseudo Konami Code (Playing Secret)" % name)
			pseudo_konami_code_inputed.clear()
			pseudo_konami_code_inputed_idx = 0
			print("%s - Pseudo Konami Code: %s" % [name, pseudo_konami_code_inputed])
			await get_tree().create_timer(0.5).timeout
			await won()
			print("MORSE")
	else:
		pseudo_konami_code_inputed.clear()
		pseudo_konami_code_inputed_idx = 0
		print("%s - Pseudo Konami Code (Wrong Input, Reseting Inputs)" % name)
		print(pseudo_konami_code_inputed)

func init_buttons() -> void:
	var idx: int = 0
	for button: ThreeDButton in $Buttons.get_children():
		button.pressed.connect(
			func(): check_cat_status(CAT_STATUS.values()[idx])
		)
		idx += 1

func init_cat() -> void:
	cat_50_50 = false
	cat_alive = randi_range(0, 1) == 1
	if not cat_alive: cat_50_50 = randi_range(0, 1) == 1
	set_cat_status()

func set_cat_status() -> void:
	if cat_alive: cat_status = CAT_STATUS.ALIVE
	else:
		if cat_50_50: cat_status = CAT_STATUS.MID
		else: cat_status = CAT_STATUS.DEAD
	
	print("Cat Status: %s" % CAT_STATUS.keys()[cat_status])

func check_cat_status(status_to_check: CAT_STATUS) -> void:
	update_pseudo_konami_code(status_to_check)
	if status_to_check == cat_status: right()
	else: wrong()

func right() -> void:
	mistakes = clampi(mistakes + 1, -1, 5)
	play_sfx("res://assets/sfxs/box_cat_right_choice_sfx.mp3")
	schrodinger_cat_interface.right()
	schrodinger_cat_interface.write_terminal(". Right Answer! %d Mistakes Left (+1 Mistake)" % mistakes)
	schrodinger_cat_interface.up_mistakes_progress_bar()
	if rounds >= max_rounds: won()
	else:
		rounds = clampi(rounds + 1, 1, max_rounds)
		schrodinger_cat_interface.up_progress_bar(1.0)
		init_cat()

func wrong() -> void:
	init_cat()
	mistakes = clampi(mistakes - 1, -1, 5)
	play_sfx("res://assets/sfxs/box_cat_wrong_choice_sfx.mp3")
	schrodinger_cat_interface.wrong()
	schrodinger_cat_interface.write_terminal(". Wrong Answer! %d Mistakes Left (-1 Mistake)" % mistakes)
	schrodinger_cat_interface.lower_mistakes_progress_bar()
	if mistakes < 0:
		mistakes = 5
		rounds = 1
		schrodinger_cat_interface.write_terminal(". Game Over. Reseting all the player's progress")
		schrodinger_cat_interface.init_progress_bar(float(max_rounds))
		schrodinger_cat_interface.init_mistakes_progress_bar()
		await get_tree().create_timer(0.5).timeout
		schrodinger_cat_interface.terminal.text = ""

func won() -> void:
	OS.alert(
		'''
		Estás haciendo bien tu trabajo, perrito de mierda. Aquí tienes una parte del código secreto que el libro me encargó que te diera si superabas el superjuego de la máquina recreativa.
		¡Que Dragon's Lair se prepare para lo que se le viene encima en cuanto a diversión!
		
		[%d]
		''' % SecretCodeManager.schrodinger_cat_right_answer_value,
		"Por parte de Diego"
	)
	
	$PlayerDetectionArea/CollisionShape.disabled = true
	if player:
		player.can_crouch = true
		player.can_jump = true
		player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(0.5).timeout
	queue_free()

func play_sfx(sfx_path: String) -> void:
	if FileAccess.file_exists(sfx_path):
		sfx_audio_stream_player_3d.stop()
		sfx_audio_stream_player_3d.stream = load(sfx_path)
		sfx_audio_stream_player_3d.play()

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		if body.is_crouching: return
		player = body
		control_indication.visible = not(player_captured)

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		if not player_captured: player = null
		control_indication.hide()
