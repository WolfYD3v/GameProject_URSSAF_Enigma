extends Node

const ANTI_CHEAT_ALERT_PACKED_SCENE: PackedScene = preload("res://scenes/anti_cheat_alert/anti_cheat_alert.tscn")

var anti_cheat_alert_scene: AntiCheatAlert = null
var saved_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	pass

func try_begin() -> void:
	if OS.get_name() != "Web" and DenuvoLikeShit.normal_gamemode:
		_open_check_focus_loop()

func _open_check_focus_loop() -> void:
	await get_tree().create_timer(0.5).timeout
	if get_viewport().get_window().has_focus():
		if anti_cheat_alert_scene: destroy_anti_cheat_alert()
	else: jj()
	
	_open_check_focus_loop()

func jj() -> void:
	if anti_cheat_alert_scene: return
	
	saved_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	anti_cheat_alert_scene = ANTI_CHEAT_ALERT_PACKED_SCENE.instantiate()
	add_child(anti_cheat_alert_scene)

func destroy_anti_cheat_alert() -> void:
	Input.mouse_mode = saved_mouse_mode
	anti_cheat_alert_scene.queue_free()
	anti_cheat_alert_scene = null
