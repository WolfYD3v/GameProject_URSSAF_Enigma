extends Control
class_name SchrodingerCatInterface

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var mistakes_progress_bar: ProgressBar = $MistakesProgressBar
@onready var box_cat_texture: TextureRect = $BoxCatTexture
@onready var right_bip: ColorRect = $RightBip
@onready var wrong_bip: ColorRect = $WrongBip
@onready var terminal: RichTextLabel = $Terminal

func _ready() -> void:
	right_bip.hide()
	wrong_bip.hide()
	init_mistakes_progress_bar()
	box_cat_texture.scale = Vector2(0.6, 0.6)
	animate_box_cat()

func animate_box_cat() -> void:
	await get_tree().create_timer(1.5).timeout
	box_cat_texture.flip_h = not(box_cat_texture.flip_h)
	box_cat_texture.scale = Vector2(0.7, 0.7)
	await get_tree().create_timer(1.5).timeout
	box_cat_texture.flip_h = not(box_cat_texture.flip_h)
	box_cat_texture.scale = Vector2(0.6, 0.6)
	animate_box_cat()

func init_progress_bar(max_value: float) -> void:
	progress_bar.max_value = max_value
	progress_bar.value = 0.0

func up_progress_bar(by_value: float) -> void:
	progress_bar.value += by_value

func init_mistakes_progress_bar() -> void:
	mistakes_progress_bar.max_value = 5.0
	mistakes_progress_bar.value = 5.0

func up_mistakes_progress_bar() -> void:
	mistakes_progress_bar.value += 1.0

func lower_mistakes_progress_bar() -> void:
	mistakes_progress_bar.value -= 1.0

func right() -> void:
	right_bip.show()
	await get_tree().create_timer(1.5).timeout
	right_bip.hide()

func wrong() -> void:
	wrong_bip.show()
	await get_tree().create_timer(2.0).timeout
	wrong_bip.hide()

func write_terminal(text: String) -> void:
	terminal.text += "\n%s" % text
