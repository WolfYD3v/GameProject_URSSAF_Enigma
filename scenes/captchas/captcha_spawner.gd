extends Node
class_name CaptchaSpawner

func _ready() -> void:
	pass

func spawn_random(at_node: Node) -> void:
	CaptchatsData.set_random_captcha()
	print("Random Captcha Spawned: %s" % CaptchatsData.get_captchat())
	spawn(at_node)

func spawn(at_node: Node) -> void:
	var captcha_scene_path: String = CaptchatsData.get_captchat()
	if captcha_scene_path != "":
		var captcha_packed_scene: PackedScene = load(captcha_scene_path)
		var captcha_scene: BaseCaptcha = captcha_packed_scene.instantiate()
		at_node.add_child(captcha_scene)
		captcha_scene.set_anchors_preset(Control.PRESET_FULL_RECT)
