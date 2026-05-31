extends Node3D
class_name MainMenu

@onready var song_audio_stream_player: AudioStreamPlayer = $SongAudioStreamPlayer
@onready var main_menu_2d_interface: MainMenu2DInterface = $GUISubViewport/MainMenu2DInterface

var can_be_freed: bool = false:
	set(value):
		can_be_freed = value
		if value: queue_free()

func _ready() -> void:
	$GUISubViewport/Him.hide()
	$GUISubViewport/Him.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	setup_song()
	main_menu_2d_interface.animate()

func _input(event: InputEvent) -> void:
	var set_free: bool = false
	
	if event is InputEventKey or event is InputEventMouseButton:
		get_tree().paused = false
		set_free = randi_range(1, 50) != 37
		if set_free: can_be_freed = true
	if event is InputEventKey and not set_free: can_be_freed = true

func setup_song() -> void:
	var random_chance: int = randi_range(1, 50)
	
	if random_chance >= 38:
		song_audio_stream_player.pitch_scale = 2.5
		main_menu_2d_interface.animation_scale = 7.5
		_him()
	song_audio_stream_player.play()

func _him() :
	await get_tree().create_timer(15.0).timeout
	$GUISubViewport/Him.show()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		$GUISubViewport/Him, "modulate",
		Color(1.0, 1.0, 1.0, 1.0), 20.0
	)
	tween.tween_property(
		song_audio_stream_player, "volume_db",
		24.0, 20.0
	)
	tween.tween_property(
		song_audio_stream_player, "pitch_scale",
		0.15, 20.0
	)
	tween.finished.connect(
		func():
			main_menu_2d_interface.tween.kill()
			await get_tree().create_timer(3.0).timeout
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			OS.alert("Him is on this floor, him is going up", " ")
			get_tree().quit()
	)
