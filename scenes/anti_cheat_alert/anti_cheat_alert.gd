extends Window
class_name AntiCheatAlert

@export_range(0.1, 0.2, 0.1, "hide_control", "or_greater") var waiting_time: float = 10.0

@onready var timer: Timer = $Timer

var ee: float = 0.5

func _ready() -> void:
	$Control/Label2.hide()
	hide()
	force_native = true
	popup_centered()
	
	timer.timeout.connect(
		func():
			$Control/Label.text = "0.0"
			await get_tree().create_timer(0.5).timeout
			OS.alert("You can't let the main window game unfocused like that, you cheater", " ")
			get_tree().quit()
	)
	timer.start(waiting_time)
	pp()

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		$Control/Label.text = str(
			snappedf(timer.time_left, 0.01)
		)
		$Control/ColorRect2.material.set_shader_parameter(
			"pixelation",
			$Control/ColorRect2.material.get_shader_parameter("pixelation") + 0.00002
		)
		$AudioStreamPlayer.volume_db += 0.1
		$AudioStreamPlayer.pitch_scale += 0.0001
		ee = clampf(ee - 0.001, 0.05, 999.9)
		$Control/ColorRect3.color += Color(255, 0, 0, 0.0015)
		$Control/TextureRect.modulate += Color(1.0, 1.0, 1.0, 0.00005)
		size += Vector2i(2, 3)

func pp() -> void:
	$Control/Label2.visible = not($Control/Label2.visible)
	await get_tree().create_timer(ee).timeout
	pp()

func _on_close_requested() -> void:
	OS.alert("Nah, u cant", " ")
