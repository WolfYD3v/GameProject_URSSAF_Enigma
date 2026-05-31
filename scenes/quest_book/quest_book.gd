extends StaticBody3D
class_name QuestBook

signal page_explored(page_idx: int)

@onready var gui: CanvasLayer = $GUI
@onready var pages: Control = $GUI/Pages
@onready var control_indication: MeshInstance3D = $ControlIndication
@onready var player_spot_mesh: MeshInstance3D = $PlayerSpotMesh
@onready var buttons: HBoxContainer = $GUI/Buttons

@export var keep_pages_count: bool = true
@export var unlock_all_pages: bool = false

var player: Player = null
var current_page_idx: int = 0
var max_pages_count: int = 0
var max_page_idx_unlocked: int = 3
var pages_already_explored: Array[int] = []

func _ready() -> void:
	if unlock_all_pages: max_page_idx_unlocked = pages.get_child_count() - 1
	
	control_indication.hide()
	gui.hide()
	
	max_pages_count = pages.get_child_count() - 1
	init_pages()
	hide_pages()
	set_page_visible(current_page_idx, true)
	set_buttons_clickability()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_interact"): take_a_look()
	if gui.visible:
		if Input.is_key_pressed(KEY_RIGHT): next_page()
		if Input.is_key_pressed(KEY_LEFT): previous_page()

func take_a_look() -> void:
	if not player or player.is_crouching: return
	player.can_move = gui.visible
	player.can_crouch = gui.visible
	player.can_jump = gui.visible
	player.can_rotate = gui.visible
	
	gui.visible = not(gui.visible)
	if gui.visible: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_control_indication_visibility()
	emit_page_explored_signal()
	

func init_pages() -> void:
	var page_nb: int = 1
	
	for page: QuestBookPage in pages.get_children():
		if keep_pages_count:
			page.page_nb = page_nb
			page.max_pages_count = max_pages_count + 1
			page.setup_pages_count()
			page_nb += 1
		else: page.pages_count_rich_text_label.queue_free()

func set_buttons_clickability() -> void:
	buttons.get_node("PreviousPageButton").disabled = current_page_idx <= 0
	buttons.get_node("NextPageButton").disabled = current_page_idx >= max_pages_count
	if current_page_idx >= max_page_idx_unlocked: buttons.get_node("NextPageButton").disabled = true

func hide_pages() -> void:
	for page: QuestBookPage in pages.get_children(): page.hide()

func set_page_visible(page_idx: int, visibility: bool) -> void:
	pages.get_child(page_idx).visible = visibility

func next_page() -> void:
	if current_page_idx + 1 > max_page_idx_unlocked: return
	
	set_page_visible(current_page_idx, false)
	current_page_idx = clampi(
		current_page_idx + 1,
		0, max_pages_count
	)
	emit_page_explored_signal()
	set_page_visible(current_page_idx, true)
	set_buttons_clickability()

func previous_page() -> void:
	set_page_visible(current_page_idx, false)
	current_page_idx = clampi(
		current_page_idx - 1,
		0, max_pages_count
	)
	emit_page_explored_signal()
	set_page_visible(current_page_idx, true)
	set_buttons_clickability()

func unloack_next_page() -> void:
	max_page_idx_unlocked = clampi(
		max_page_idx_unlocked + 1,
		0, max_pages_count
	)

func set_control_indication_visibility() -> void:
	control_indication.visible = player != null

func emit_page_explored_signal():
	if not current_page_idx in pages_already_explored:
		pages_already_explored.append(current_page_idx)
		page_explored.emit(current_page_idx + 1)

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		if not player.is_crouching: set_control_indication_visibility()

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		set_control_indication_visibility()
