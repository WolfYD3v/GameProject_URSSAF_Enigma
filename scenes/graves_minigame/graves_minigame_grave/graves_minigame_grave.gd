extends StaticBody3D
class_name GravesMinigameGrave

@onready var person_name_text: MeshInstance3D = $PersonNameText
@onready var idx_text: MeshInstance3D = $IDXText

@export var idx: int = 0
@export var person_name: String = ""

func _ready() -> void:
	pass

func init() -> void:
	person_name_text.mesh = set_text_mesh(person_name_text, person_name)
	idx_text.mesh = set_text_mesh(idx_text, str(idx))

func set_text_mesh(mesh_instance: MeshInstance3D, text: String) -> TextMesh:
	var text_mesh: TextMesh = mesh_instance.mesh.duplicate()
	text_mesh.text = text
	
	return text_mesh
