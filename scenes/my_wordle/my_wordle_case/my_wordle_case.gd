extends ColorRect
class_name MyWordleCase

@onready var label: Label = $Label

@export var right_character_color: Color = Color(0.0, 0.431, 0.0, 1.0)
@export var normal_character_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var wrong_character_color: Color = Color(1.0, 0.0, 0.0, 1.0)
@export var character: String = "_":
	set(value):
		character = value
		if label: label.text = character
@export var empty_character: String = "_"
@export var character_right: bool = false

func _ready() -> void:
	color = normal_character_color
	character = empty_character

func show_character_rightness() -> void:
	if character_right: color = right_character_color
	else: color = wrong_character_color
