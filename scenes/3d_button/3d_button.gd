extends MeshInstance3D
class_name ThreeDButton

signal pressed

@onready var text_mesh: MeshInstance3D = $TextMesh
@onready var timer: Timer = $Timer
@onready var control_indication: MeshInstance3D = $ControlIndication
@onready var mesh_instance_3d: MeshInstance3D = $MouseDetedtionArea/MeshInstance3D

@export var text: String = ""

var mouse_detected: bool = false
var tween

func _ready() -> void:
	control_indication.hide()
	setup_text_mesh()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: _try_press()

func setup_text_mesh() -> void:
	var _mesh: TextMesh = text_mesh.mesh.duplicate()
	text_mesh.mesh = _mesh
	
	if not text.is_empty(): text_mesh.mesh.text = text
	else: text_mesh.mesh.text = "txt"

func _try_press() -> void:
	if mouse_detected and timer.is_stopped():
		pressed.emit()
		timer.start()

func _on_mouse_detedtion_area_mouse_entered() -> void:
	mouse_detected = true
	control_indication.show()
	if mesh_instance_3d:
		mesh_instance_3d.queue_free()
		mesh_instance_3d = null

func _on_mouse_detedtion_area_mouse_exited() -> void:
	mouse_detected = false
	control_indication.hide()
