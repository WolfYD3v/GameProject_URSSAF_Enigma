extends QuestBookPage
class_name QuestBookEncourgment1Page

@onready var node_3d: Node3D = $SubViewport/Node3D
@onready var radio_texture_rect: TextureRect = $Right/MarginContainer/Nodes/RadioTextureRect

var rotation_speed_accel: float = 1.0

func _ready() -> void:
	node_3d.rotation.y = deg_to_rad(0.0)

func _process(delta: float) -> void:
	node_3d.rotation.y -= deg_to_rad(15.0 * delta * rotation_speed_accel)

func _on_radio_texture_rect_mouse_entered() -> void:
	rotation_speed_accel = 3.0

func _on_radio_texture_rect_mouse_exited() -> void:
	rotation_speed_accel = 1.0
