extends Control
class_name MainMenu2DInterface

@onready var start_info_label: Label = $StartInfoLabel

@export var animation_scale: float = 1.0

var tween

func _ready() -> void:
	setup_start_info_label()

func setup_start_info_label() -> void:
	var random_chance: int = randi_range(1, 15)
	
	if random_chance < 4:
		start_info_label.text = "Press anything to start"
	elif random_chance > 3 and random_chance < 10:
		start_info_label.text = "Press anything to start (or click)"
	else:
		start_info_label.text = "Press anything to start (or click, if u prefer...)"

func animate() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	
	var max_scale_value: float = randf_range(1.05, 1.1) * animation_scale
	var min_scale_value: float = randf_range(0.95, 1.0) / animation_scale
	var random_tweening_duration: float = randf_range(4.5, 6.0) / animation_scale
	
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(
		start_info_label, "scale",
		Vector2(max_scale_value, max_scale_value),
		random_tweening_duration
	)
	tween.tween_property(
		start_info_label, "scale",
		Vector2(min_scale_value, min_scale_value),
		random_tweening_duration * 1.5
	).set_delay(random_tweening_duration)
	
	await tween.finished
	await get_tree().create_timer(
		random_tweening_duration / 10.0
	).timeout
	animate()
