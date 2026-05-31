extends Node3D
class_name GravesMinigame

@onready var markers_node: Node3D = $MarkersNode

const GRAVE: PackedScene = preload("res://scenes/graves_minigame/graves_minigame_grave/graves_minigame_grave.tscn")
const PERSON_NAMES: Array[String] = [
	"Lucy", "Paul", "Supervisor", "Sally",
	"Mark", "Julien", "CEO", "You"
]
var markers_collection: Array[Marker3D] = []

func _ready() -> void:
	set_markers_collection()

func set_markers_collection() -> void:
	markers_collection = []
	for marker: Marker3D in markers_node.get_children():
		markers_collection.append(marker)
	print("Markers Collection: " + str(markers_collection))

func spawn_graves() -> void:
	var grave_idx: int = 1
	for loop: int in range(8):
		if markers_collection.is_empty(): break
		var random_marker: Marker3D = markers_collection.pick_random()
		var new_grave: GravesMinigameGrave = GRAVE.instantiate()
		add_child(new_grave)
		new_grave.name = "Grave%d" % grave_idx
		new_grave.idx = grave_idx
		new_grave.person_name = PERSON_NAMES[grave_idx - 1]
		new_grave.init()
		new_grave.global_position = random_marker.global_position
		new_grave.global_rotation = random_marker.global_rotation
		
		random_marker.queue_free()
		markers_collection.erase(random_marker)
		grave_idx += 1
		
	if markers_collection.is_empty(): markers_node.queue_free()
