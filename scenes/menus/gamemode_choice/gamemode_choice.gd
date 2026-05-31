extends Control
class_name GamemodeChoice

@onready var baby_mode_button: Button = $MarginContainer/NodesContainer/ButtonsContainer/BabyModeButton
@onready var normal_mode_button: Button = $MarginContainer/NodesContainer/ButtonsContainer/NormalModeButton
@onready var normal_mode_text: RichTextLabel = $MarginContainer/NodesContainer/NormalModeText
@onready var title_text: RichTextLabel = $MarginContainer/NodesContainer/TitleText
@onready var margin_container: MarginContainer = $MarginContainer
@onready var lock_mouse: ColorRect = $LockMouse

const DEV_INTRO_PACKED_SCENE: PackedScene = preload("res://scenes/menus/dev_intro_menu/dev_intro_menu.tscn")

var gamemode: String = "":
	set(value):
		gamemode = value
		title_text.text = "[u][b]%s[/b][/u] %s" % [
			TranslationServer.tr("TITLE"), gamemode
		]
var normal_gamemode: bool = false:
	set(value):
		normal_gamemode = value
		DenuvoLikeShit.normal_gamemode = value
		normal_mode_text.visible = normal_gamemode

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	lock_mouse.hide()
	margin_container.hide()
	if OS.get_name() == "Web": a()
	gamemode = TranslationServer.tr("EASY_GM")
	normal_mode_text.hide()
	
	await get_tree().create_timer(1.0).timeout
	margin_container.show()

func _on_baby_mode_button_mouse_entered() -> void:
	baby_mode_button.text = TranslationServer.tr("BABY_GM")

func _on_baby_mode_button_mouse_exited() -> void:
	baby_mode_button.text = TranslationServer.tr("EASY_GM")

func _on_normal_mode_button_mouse_entered() -> void:
	normal_mode_button.text = TranslationServer.tr("NORMAL_GM")

func _on_normal_mode_button_mouse_exited() -> void:
	normal_mode_button.text = TranslationServer.tr("HARDCORE_GM")

func _on_baby_mode_button_pressed() -> void:
	normal_gamemode = false
	gamemode = TranslationServer.tr("EASY_GM")

func _on_normal_mode_button_pressed() -> void:
	normal_gamemode = true
	gamemode = TranslationServer.tr("HARDCORE_GM")

func _disable_buttons_in(node: Node) -> void:
	for child_node: Node in node.get_children():
		if child_node is Button: child_node.disabled = true
		if child_node.get_child_count() > 0:
			call_deferred("_disable_buttons_in", child_node)

func _on_continue_button_pressed() -> void:
	lock_mouse.show()
	_disable_buttons_in(self)
	var do_password_stuff: bool = true
	if do_password_stuff:
		SecretCodeManager.generate()
		await SecretCodeManager.secret_code_generated
	else:
		SecretCodeManager._raw_secret_code = "NO_PASSWORD"
		SecretCodeManager._encrypted_secret_code = "NO_PASSWORD"
	print("\nThe raw secret code is: %s" % SecretCodeManager._raw_secret_code)
	print("The encrypted secret code is: %s" % SecretCodeManager._encrypted_secret_code)
	
	a()

func a():
	if OS.get_name() != "Web": DenuvoLikeShit.start_checking()
	AdvertManager.try_begin()
	AntiCheat.try_begin()
	SceneManager.add_scene("DevIntro", DEV_INTRO_PACKED_SCENE)
	SceneManager.replace_scene("DevIntro")
