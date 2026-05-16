extends Node3D
class_name DevIntroMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var me_label: Label = $GUI/Control/GUI/VBoxContainer1/MeLabel
@onready var jam_label: Label = $GUI/Control/GUI/VBoxContainer2/JamLabel
@onready var radio: Radio = $Radio
@onready var invert_colors_shader_overlay: ColorRect = $GUI/InvertColorsShaderOverlay
@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer

const URSSAF_BUILDING_PACKED_SCENE: PackedScene = preload("res://scenes/urssaf_building/urssaf_building.tscn")

var go_crazy: bool = randi_range(1, 50) >= 45

func _ready() -> void:
	$GUI/Label.hide()
	invert_colors_shader_overlay.hide()
	try_go_crazy()
	$GUI/Control.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	animation_player.play("intro")
	await animation_player.animation_finished
	
	if go_crazy:
		for loop: int in range(randi_range(3, 6)):
			invert_colors_shader_overlay.visible = not(
				invert_colors_shader_overlay.visible
			)
			$GUI/Label.visible = not ($GUI/Label.visible)
			radio.play()
			sfx_audio_stream_player.play()
			await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
			invert_colors_shader_overlay.visible = not(
				invert_colors_shader_overlay.visible
			)
			$GUI/Label.visible = not ($GUI/Label.visible)
			sfx_audio_stream_player.stop()
			sfx_audio_stream_player.volume_db += 1.5
			await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
		var mat: ShaderMaterial = invert_colors_shader_overlay.material
		mat.set_shader_parameter("brightness", 0.05)
		invert_colors_shader_overlay.show()
		$GUI/Label.show()
		await get_tree().create_timer(0.1).timeout
	else: await get_tree().create_timer(5.0).timeout
	
	SceneManager.remove_scene("DevIntro")
	SceneManager.add_scene("UrssafBuilding", URSSAF_BUILDING_PACKED_SCENE)
	SceneManager.replace_scene("UrssafBuilding")

func try_go_crazy() -> void:
	if go_crazy:
		radio.songs.set(
			0, load("res://assets/voices/dev_intro_crazy_voice.wav")
		)
		me_label.text = "A perfect and amazing WolfY_D3v's game (made by a godlike chad)"
		jam_label.text = "Made 4 da"
