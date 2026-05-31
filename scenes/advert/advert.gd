extends Window
class_name Advert

@onready var texture_rect: TextureRect = $TextureRect

@export var adverts: Array[String] = []

func _ready() -> void:
	size = Vector2(
		randf_range(250.0, 550.0),
		randf_range(150.0, 450.0)
	)
	texture_rect.texture = load(adverts.pick_random())
	hide()
	force_native = true
	popup_centered()

func _on_close_requested() -> void:
	queue_free()
