extends Node
class_name Game

const URSSAF_BUILDING_PACKED_SCENE: PackedScene = preload("res://scenes/urssaf_building/urssaf_building.tscn")

func _ready() -> void:
	await SecretCodeManager.secret_code_generated
	print("The secret code is: %s" % SecretCodeManager.secret_code)
	
	SceneManager.add_scene("UrssafBuilding", URSSAF_BUILDING_PACKED_SCENE)
	SceneManager.replace_scene("UrssafBuilding")
	get_tree().root.get_node("Game").queue_free()
