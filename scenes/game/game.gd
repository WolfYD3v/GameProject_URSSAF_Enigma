extends Node
class_name Game

@onready var label: Label = $Interface/Label

@export var do_password_stuff: bool = true

const DEV_INTRO_PACKED_SCENE: PackedScene = preload("res://scenes/menus/dev_intro_menu/dev_intro_menu.tscn")

var label_texts_array: Array[String] = [
	"Generating something...",
	"Doing some background work...",
	"Tried to rick roll you, but failed.\nwhat a shame...",
	"Travail dur !",
	"A banger for table 12 coming up!",
	"Entrée 6 sur %d de la liste sélectionnée" % 11,
	"Je cook de l'aléatoire Walter",
	"1 chance sur 50 que le title screen soit différent ;)",
	"Yeah.",
	"I will encrypt a String soon",
	"Vers la super encryption, et au delà !"
]

func _ready() -> void:
	label.text = label_texts_array.pick_random()
	
	if do_password_stuff:
		SecretCodeManager.generate()
		await SecretCodeManager.secret_code_generated
	else:
		SecretCodeManager._raw_secret_code = "NO_PASSWORD"
		SecretCodeManager._encrypted_secret_code = "NO_PASSWORD"
	print("\nThe raw secret code is: %s" % SecretCodeManager._raw_secret_code)
	print("The encrypted secret code is: %s" % SecretCodeManager._encrypted_secret_code)
	
	SceneManager.add_scene("DevIntro", DEV_INTRO_PACKED_SCENE)
	SceneManager.replace_scene("DevIntro")
	get_tree().root.get_node("Game").queue_free()
