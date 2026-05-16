extends Node3D
class_name UrssafBuilding_Area2

@onready var player_entering_trigger_area: Area3D = $PlayerEnteringTriggerArea
@onready var urssaf_building_wall_3: StaticBody3D = $UrssafBuildingWall3
@onready var ambiance_audio_stream_player_3d: AudioStreamPlayer3D = $AmbianceAudioStreamPlayer3D

func _ready() -> void:
	pass

func _on_player_entering_trigger_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player_entering_trigger_area.queue_free()
		if not get_parent().get_parent().skip_begin:
			get_parent().get_parent().try_destroy_area(1)
		urssaf_building_wall_3.position.z = 0.0
		urssaf_building_wall_3.get_node("AudioStreamPlayer").play()
		ambiance_audio_stream_player_3d.play()

func _on_quest_book_page_unlocked(page_idx: int) -> void:
	print("Page Idx: %d" % page_idx)
