extends QuestBookPage
class_name QuestBookPartLPage

@onready var popup_button: Button = $Right/MarginContainer/Nodes/PopupButton

func _ready() -> void:
	$Right/MarginContainer/Nodes/Label1.text = SecretCodeManager.math_safe_calcul

func _on_popup_button_pressed() -> void:
	popup_button.disabled = true
	OS.alert("So.\nThis is a shit situation—I have to finish this game ASAP. Luckily, all I have left to do is explain all the encryption, and I'm good to go!!!!\nSo here's the rest of the code—it's still random, but consider it a gift.\n%s" % SecretCodeManager.junk, "WolfY_D3v")
