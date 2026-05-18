extends Node
class_name FileTool

signal keep_going
signal confirmed

@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	file_dialog.file_selected.connect(func(_path: String): keep_going.emit())
	file_dialog.confirmed.connect(func(): keep_going.emit())
	
	#await download_file("TEST1.txt", "test1")
	#download_file("TEST2.txt", "test2", true)
	
	#upload_file()

func download_file(filename: String, file_content: String, forced: bool = false) -> void:
	var filepath: String = ""
	
	if forced: filepath = "user://%s" % filename
	else: filepath = await _get_download_path_consently(filename)
	
	if OS.get_name() != "Web": _download_file_desktop(filepath, file_content)
	else: _download_file_web(file_content, filename)

func _download_file_desktop(filepath: String, file_content: String) -> void:
	if filepath.is_empty(): return
	
	if FileAccess.file_exists(filepath): DirAccess.remove_absolute(filepath)
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_string(file_content)
		file.close()
		confirmed.emit()
		OS.shell_open(
			ProjectSettings.globalize_path(filepath)
		)

func _download_file_web(file_content: String, filename: String):
	# On convertit le texte en PoolByteArray (PackedByteArray en Godot 4)
	# et on l'encode en Base64 pour que le navigateur puisse le lire facilement
	var base64_content = Marshalls.utf8_to_base64(file_content)
	
	# Création d'une URL de téléchargement en JavaScript (Data URL)
	var mime_type = "text/plain" # Change selon le type de fichier (ex: application/json)
	var data_url = "data:" + mime_type + ";base64," + base64_content
	
	# Code JavaScript pour créer un clic invisible sur un lien de téléchargement
	var js_code = """
	var a = document.createElement('a');
	a.href = '{url}';
	a.download = '{filename}';
	document.body.appendChild(a);
	a.click();
	document.body.removeChild(a);
	""".format({"url": data_url, "filename": filename})
	
	# On exécute le code dans le navigateur du joueur
	JavaScriptBridge.eval(js_code)
	confirmed.emit()

func _get_download_path_consently(filename: String) -> String:
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.current_file = filename
	file_dialog.popup_centered()
	
	await keep_going
	return "%s/%s" % [file_dialog.current_dir, file_dialog.current_file]

func upload_file() -> Variant:
	var file_data: String = ""
	
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.popup_centered()
	await keep_going
	
	var file = FileAccess.open(file_dialog.current_path, FileAccess.READ)
	if file:
		file_data = file.get_as_text()
		confirmed.emit()
	
	print(file_data)
	return file_data
