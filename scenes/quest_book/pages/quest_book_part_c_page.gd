extends QuestBookPage
class_name QuestBookPartCPage

@onready var verify_humanity_button: Button = $Right/MarginContainer/Nodes/VerifyHumanityButton
@onready var captcha_spawner: CaptchaSpawner = $CaptchaSpawner

func _ready() -> void:
	verify_humanity_button.disabled = false

func _on_verify_humanity_button_pressed() -> void:
	verify_humanity_button.disabled = true
	
	captcha_spawner.spawn(captcha_spawner)
