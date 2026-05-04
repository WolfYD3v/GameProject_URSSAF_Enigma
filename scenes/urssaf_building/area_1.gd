extends Node3D
class_name UrssafBuilding_Area1

@onready var train: Train = $Train
@onready var invisible_wall_1: StaticBody3D = $InvisibleWall1
@onready var diego: Diego = $Diego

func _ready() -> void:
	diego.hide()

func _on_intro_button_3d_pressed() -> void:
	await get_tree().create_timer(2.5).timeout
	train.play_audio()
	var train_tween = get_tree().create_tween()
	train_tween.tween_property(
		train, "position:z",
		train.position.z * -2, 3.5
	)
	await get_tree().create_timer(1.5).timeout
	diego.show()
	await get_tree().create_timer(2.0).timeout
	train.stop_audio()
	train_tween.kill()
	
	await get_tree().create_timer(1.5).timeout
	diego.talk = true
	
	await diego.diego_dialog_box.finished
	invisible_wall_1.queue_free()

func _on_player_leaving_trigger_area_body_entered(body: Node3D) -> void:
	if body is Player and diego:
		diego.explode()
		diego = null
