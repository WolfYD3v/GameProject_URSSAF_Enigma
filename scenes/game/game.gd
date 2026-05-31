extends Node
class_name Game

@onready var label: Label = $Interface/Label

const GAMEMODE_CHOICE_PACKED_SCENE: PackedScene = preload("res://scenes/menus/gamemode_choice/gamemode_choice.tscn")

var label_texts_array: Array[String] = [
	"Generating something soon...",
	"Doing some background work soon...",
	"Tried to rick roll you, but failed.\nwhat a shame...",
	"Travail dur ! (soon)",
	"A banger for table 12 coming up!",
	"Entrée 6 sur %d de la liste sélectionnée" % 11,
	"Je cook de l'aléatoire Walter (soon)",
	"1 chance sur 50 que le title screen soit différent ;)",
	"Yeah.",
	"I will encrypt a String soon",
	"Vers la super encryption, et au delà !"
]

func _ready() -> void:
	label.text = label_texts_array.pick_random()
	
	SceneManager.add_scene("GamemodeChoice", GAMEMODE_CHOICE_PACKED_SCENE)
	SceneManager.replace_scene("GamemodeChoice")
	get_tree().root.get_node("Game").queue_free()
