extends HBoxContainer
class_name QuestBookPage

@onready var pages_count_rich_text_label: RichTextLabel = $Right/MarginContainer/Nodes/PagesCountRichTextLabel

@export_range(1, 2, 1, "or_greater") var page_nb: int = 1
@export_range(1, 2, 1, "or_greater") var max_pages_count: int = 1

func _ready() -> void:
	setup_pages_count()

func setup_pages_count() -> void:
	page_nb = clampi(page_nb, 1, max_pages_count)
	pages_count_rich_text_label.text = "[u]page %d / %d[/u]" % [
		page_nb, max_pages_count
	]
