extends QuestBookPage
class_name QuestBookEncyptionBPage

@onready var get_big_file_button: Button = $Left/MarginContainer/Nodes/GetBigFileButton
@onready var file_tool: FileTool = $FileTool
@onready var get_file_button: Button = $Right/MarginContainer/Nodes/GetFileButton

func _ready() -> void:
	pass

func _on_get_big_file_button_pressed() -> void:
	get_big_file_button.disabled = true
	var file_content: String = "suffled character at index <-> not suffled character at index\n\n"
	for key: int in Cryptographer.suffled_base_64_associations.keys():
		file_content += "%d <-> %d\n" % [key, Cryptographer.suffled_base_64_associations.get(key)]
	file_content += '''


Note.
If you have read the entire file, you will notice that a single index appears multiple times. And there is a good reason for this.
Here is how a typical scrambling operation works:
- Base text: “jspf”
- Scrambled text: “”

Step 1:
- Index: 2
- Scrambled text: “p”
- Base text: “jsf”
Step 2:
- Index: 0
- Scrambled text: “pj”
- Base text: “sf”
Step 3:
- Index: 1
- Scrambled text: “pjf”
- Base text: “s”
Step 4:
- Index: 0
- Scrambled text: “pjfs”
- Base text: “”
Done!
	'''
	file_tool.download_file("suffled_base_64_order.txt", file_content, true)

func _on_get_file_button_pressed() -> void:
	get_file_button.disabled = true
	var file_content: String = str(Cryptographer.alphabet_associations)
	file_tool.download_file("mono_alphabetic_substitution.txt", file_content, true)
