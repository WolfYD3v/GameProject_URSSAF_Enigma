extends Node3D
class_name UrssafBuilding_Area2

@onready var player_entering_trigger_area: Area3D = $PlayerEnteringTriggerArea
@onready var urssaf_building_wall_3: StaticBody3D = $UrssafBuildingWall3
@onready var ambiance_audio_stream_player_3d: AudioStreamPlayer3D = $AmbianceAudioStreamPlayer3D
@onready var graves_minigame: GravesMinigame = $GravesMinigame
@onready var mathy_minigame: MathyMinigame = $MathyMinigame

func _ready() -> void:
	pass

func spawn_at(packed_scene_to_spawn: PackedScene, position_in_area: Variant, properties_to_set: Dictionary[String, Variant] = {}) -> void:
	var scene_spawned: Node = packed_scene_to_spawn.instantiate()
	add_child(scene_spawned)
	scene_spawned.position = position_in_area
	
	for property_to_set: String in properties_to_set.keys():
		scene_spawned.set(property_to_set, properties_to_set.get(property_to_set))

func _on_player_entering_trigger_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player_entering_trigger_area.queue_free()
		if not get_parent().get_parent().skip_begin:
			get_parent().get_parent().try_destroy_area(1)
		urssaf_building_wall_3.position.z = 0.0
		urssaf_building_wall_3.get_node("AudioStreamPlayer").play()
		ambiance_audio_stream_player_3d.play()

func _on_quest_book_page_explored(page_idx: int) -> void:
	print("Book - Page %d Readed" % page_idx)
	match page_idx:
		5:
			$AudioStreamPlayer.play()
			var songs: Array[AudioStream] = [
				load("res://assets/songs/Money Money Money Modifié.mp3"),
				load("res://assets/songs/Les Inconnus - Rap-tout (vampires).mp3"),
				load("res://assets/songs/ABBA - Money, Money, Money (Official Music Video).mp3"),
				load("res://assets/songs/Je possède des thunes (Clip Intégral) - David Castello-Lopes.mp3")
			]
			spawn_at(
				load("res://scenes/radio/radio.tscn"), Vector3(2.4, 0.689, -2.0),
				{ "songs": songs, "play_mode": Radio.PLAY_MODES.RANDOM }
			)
		6: 
			$AudioStreamPlayer.play()
			mathy_minigame.spawn_things()
		8:
			$AudioStreamPlayer.play()
			graves_minigame.spawn_graves()
		13:
			$AudioStreamPlayer.play()
			spawn_at(load("res://scenes/schrodinger_cat/schrodinger_cat.tscn"), Vector3(-4.0, 0.6, -6.0))
