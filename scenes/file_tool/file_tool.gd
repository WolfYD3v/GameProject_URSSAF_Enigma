extends Node
class_name FileTool

signal keep_going
signal confirmed

@onready var file_dialog: FileDialog = $FileDialog

var canceled: bool = false
var _file_content: String = ""

func _ready() -> void:
	file_dialog.file_selected.connect(func(_path: String): keep_going.emit())
	file_dialog.confirmed.connect(func(): keep_going.emit())
	file_dialog.canceled.connect(
		func():
			print("e")
			canceled = true
			keep_going.emit()
	)
	
	#download_file("ee.txt", "r")
	#if canceled:
		#await get_tree().create_timer(0.1).timeout
		#download_file("ee.txt", "r")

func download_file(filename: String, file_content: String) -> void:
	canceled = false
	_file_content = file_content
	
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.current_file = filename
	file_dialog.popup_file_dialog()
	
	await keep_going
	var path: String = "%s/%s" % [file_dialog.current_dir, file_dialog.current_file]
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(_file_content)
		file.close()
		confirmed.emit()

func upload_file() -> Variant:
	var file_data: String = ""
	
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.popup_file_dialog()
	
	await keep_going
	var file = FileAccess.open(file_dialog.current_path, FileAccess.READ)
	if file:
		file_data = file.get_as_text()
		confirmed.emit()
	
	return file_data
