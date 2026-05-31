extends Node

const ADVERT_PACKED_SCENE: PackedScene = preload("res://scenes/advert/advert.tscn")

func _ready() -> void:
	pass

func try_begin() -> void:
	if OS.get_name() != "Web" and DenuvoLikeShit.normal_gamemode:
		_open_advert_loop()

func _open_advert_loop() -> void:
	await get_tree().create_timer(
		randf_range(85.0, 110.0)
	).timeout
	get_tree().root.call_deferred("add_child", ADVERT_PACKED_SCENE.instantiate())
	_open_advert_loop()
