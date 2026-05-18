extends Node

enum CAPTCHAT_TYPES {
	SQUARE = 1,
	IMAGE_TEXT = 2,
	DOTS = 3
}
var captchat_type: CAPTCHAT_TYPES = CAPTCHAT_TYPES.SQUARE
var captchats: Dictionary[CAPTCHAT_TYPES, String] = {
	CAPTCHAT_TYPES.SQUARE: "res://scenes/captchas/captcha_text/captcha_text.tscn",
	CAPTCHAT_TYPES.IMAGE_TEXT: "res://scenes/captchas/captcha_text/captcha_text.tscn",
	CAPTCHAT_TYPES.DOTS: "res://scenes/captchas/captcha_text/captcha_text.tscn"
}
var right_answer: String = ""

var captchat_image_answer_associations: Dictionary[String, String] = {
	"res://assets/textures/captchat/image_text/image_text_captchat_1.png": "Jk7#L9p",
	"res://assets/textures/captchat/image_text/image_text_captchat_2.png": "r3$Gv2N",
	"res://assets/textures/captchat/image_text/image_text_captchat_3.png": "9xF!P5m",
	"res://assets/textures/captchat/image_text/image_text_captchat_4.png": "a7H@8tQ",
	"res://assets/textures/captchat/image_text/image_text_captchat_5.png": "kY1^c6R",
	"res://assets/textures/captchat/image_text/image_text_captchat_6.png": "b8S+D3n",
	"res://assets/textures/captchat/image_text/image_text_captchat_7.png": "M4w=G9a",
	"res://assets/textures/captchat/image_text/image_text_captchat_8.png": "f7E*C5z",
	"res://assets/textures/captchat/image_text/image_text_captchat_9.png": "R3u?X1y",
	"res://assets/textures/captchat/image_text/image_text_captchat_10.png": "g6L{P4k",
	"res://assets/textures/captchat/image_text/image_text_captchat_11.png": "V5s]A7e",
}

func _ready() -> void:
	pass

func set_random_captcha(forced: bool = false, forced_type: CAPTCHAT_TYPES = CAPTCHAT_TYPES.SQUARE) -> void:
	if forced: captchat_type = forced_type
	else: captchat_type = CAPTCHAT_TYPES.values().pick_random()
	
	match captchat_type:
		CAPTCHAT_TYPES.SQUARE: _set_image_text_captcha()
		CAPTCHAT_TYPES.IMAGE_TEXT: _set_image_text_captcha()
		CAPTCHAT_TYPES.DOTS: _set_image_text_captcha()

func _set_image_text_captcha() -> void:
	if not captchat_image_answer_associations.is_empty():
		right_answer = captchat_image_answer_associations.values().pick_random()
	else: right_answer = "0000000"

func get_captchat() -> String:
	return captchats.get(captchat_type)
