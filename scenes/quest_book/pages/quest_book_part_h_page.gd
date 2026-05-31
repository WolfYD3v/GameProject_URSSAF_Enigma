extends QuestBookPage
class_name QuestBookPartHPage

@onready var solve_wordle_button: Button = $Left/MarginContainer/Nodes/SolveWordleButton

const MY_WORDLE_PACKED_SCENE: PackedScene = preload("res://scenes/my_wordle/my_wordle.tscn")

func _ready() -> void:
	pass

func _on_solve_wordle_button_pressed() -> void:
	solve_wordle_button.disabled = true
	add_child(MY_WORDLE_PACKED_SCENE.instantiate())
