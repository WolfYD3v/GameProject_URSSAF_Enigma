extends Node3D
class_name UrssafBuilding

@onready var map_areas: Node3D = $MapAreas

var areas: Array[Node] = []
var current_area_idx: int = 1

func _ready() -> void:
	fetch_areas()
	try_show_area(current_area_idx)

func fetch_areas() -> void:
	areas = map_areas.get_children()

func hide_all_areas() -> void:
	for area: Node in areas: area.hide()

func try_show_area(area_idx: int) -> void:
	hide_all_areas()
	for area: Node in areas:
		if area.name == "Area%d" % area_idx: area.show()

func try_hide_area(area_idx: int) -> void:
	for area: Node in areas:
		if area.name == "Area%d" % area_idx: area.hide()

func try_destroy_area(area_idx: int) -> void:
	for area: Node in areas:
		if area.name == "Area%d" % area_idx: area.queue_free()

func next_area(destroy_mode: bool) -> void:
	if destroy_mode: try_destroy_area(current_area_idx)
	else: try_hide_area(current_area_idx)
	
	current_area_idx += 1
	try_show_area(current_area_idx)
