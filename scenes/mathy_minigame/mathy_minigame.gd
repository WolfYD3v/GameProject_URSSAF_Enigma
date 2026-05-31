extends Node3D
class_name MathyMinigame

@onready var markers_node: Node3D = $MarkersNode
@onready var elements_node: Node3D = $ElementsNode

const GRAVE: PackedScene = preload("res://scenes/graves_minigame/graves_minigame_grave/graves_minigame_grave.tscn")

var markers_collection: Array[Marker3D] = []
var all_maths: Array[String] = [
	"1 + 2",
	"0 + 3",
	"5 − 2",
	"10 − 7",
	"4 − 1",
	"6 × 0,5",
	"3 × 1",
	"15 / 5",
	"12 / 4",
	"6 / 2",
	"(3×3) / 3"
]
var texts_to_set: Array[String] = ["%d" % SecretCodeManager.counting_part_multiplier]

func _ready() -> void:
	elements_node.hide()
	texts_to_set.append(all_maths.pick_random())
	set_markers_collection()
	init_numbers()

func set_markers_collection() -> void:
	markers_collection = []
	for marker: Marker3D in markers_node.get_children():
		markers_collection.append(marker)
	print("Markers Collection: " + str(markers_collection))

func init_numbers() -> void:
	var text_idx: int = 0
	for nb: MeshInstance3D in elements_node.get_children():
		if text_idx > texts_to_set.size() - 1: break
		_set_number_text(nb, texts_to_set[text_idx])
		text_idx += 1

func _set_number_text(number: MeshInstance3D, text: String) -> void:
	if number.mesh is TextMesh:
		var text_mesh: TextMesh = number.mesh.duplicate()
		text_mesh.text = text
		number.mesh = text_mesh

func spawn_things() -> void:
	for loop: int in range(2):
		if markers_collection.is_empty(): break
		var random_marker: Marker3D = markers_collection.pick_random()
		var element: Node3D = elements_node.get_child(0)
		print(element)
		if element:
			element.reparent(self)
			element.global_position = random_marker.global_position
			element.global_rotation = random_marker.global_rotation
			element.scale = random_marker.scale
		
		markers_collection.erase(random_marker)
		random_marker.queue_free()
	
	markers_collection = []
	markers_node.queue_free()
	elements_node.queue_free()
