extends QuestBookPage
class_name QuestBookEncyptionAPage

@onready var file_tool: FileTool = $FileTool

func _ready() -> void:
	pass

func _on_get_encryption_order_button_pressed() -> void:
	var file_content: String = ""
	for method: String in Cryptographer._seleted_cryptography_methods:
		if method == "cesar": file_content += "{from the first file provided by Diego} > "
		else: file_content += "%s > " % method
	file_content += "END"
	file_tool.download_file("encryption_order.txt", file_content)
