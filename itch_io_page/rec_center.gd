extends Node3D
class_name RecCenter

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$DiegoModel.rotate_y(deg_to_rad(35.0 * delta))
