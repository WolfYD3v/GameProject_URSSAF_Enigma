extends Control
class_name DiegoDialogBox

signal new_line(line_content: String)
signal finished

@onready var text_label: Label = $TextLabel

func _ready() -> void:
	hide()

func _get_dialog_data(dialog_file_path: String) -> Variant:
	var dialog_file = FileAccess.open(dialog_file_path, FileAccess.READ)
	var dialog_data: Variant = JSON.parse_string(
		dialog_file.get_as_text()
	)
	dialog_file.close()
	
	return dialog_data

func play_dialog(dialog_file_path: String) -> void:
	hide()
	if not FileAccess.file_exists(dialog_file_path): return
	var dialog_data: Variant = _get_dialog_data(dialog_file_path)
	
	show()
	for dialog_line: String in dialog_data:
		new_line.emit(dialog_line)
		text_label.text = dialog_line
		await get_tree().create_timer(
			float(dialog_line.length()) / 15.0
		).timeout
	stop_dialog()

func stop_dialog() -> void:
	hide()
	finished.emit()
