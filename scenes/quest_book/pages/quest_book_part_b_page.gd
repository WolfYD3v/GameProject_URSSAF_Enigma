extends QuestBookPage
class_name QuestBookPartBPage

@onready var download_file_button: Button = $Right/MarginContainer/Nodes/DownloadFileButton
@onready var file_tool: FileTool = $FileTool

func _ready() -> void:
	download_file_button.disabled = false

func _on_download_file_button_pressed() -> void:
	download_file_button.disabled = true
	
	await SecretCodeManager._set_counting_part()
	print(SecretCodeManager.counting_part_var)
	var file_data: String = SecretCodeManager.counting_part_text.replace(" ", "%")
	file_tool.download_file("word_count.txt", file_data, true)
