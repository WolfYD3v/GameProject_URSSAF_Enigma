extends Node

signal secret_code_generated

const _HTTP_REQUESTER_PACKED_SCENE: PackedScene = preload("res://scenes/http_requester/http_requester.tscn")

var lenght_max: int = 100
var secret_code: String = ""

func _ready() -> void:
	generate()
	print(secret_code)

func generate() -> void:
	print("Generating code...")
	secret_code = ""
	
	# Fetching the dayly Word of Wordle of today, and adds it in the secret code
	secret_code += await _get_wordle_dayly_word()
	
	# Filling the rest of the code with junk, to make it 100 characters
	for _loop: int in range(lenght_max - secret_code.length()):
		secret_code += "a"
	
	# The code is generated!
	secret_code_generated.emit()

func _get_wordle_dayly_word() -> String:
	# Add the http_requester
	var http_requester: HttpRequester = _HTTP_REQUESTER_PACKED_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(http_requester)
	await get_tree().create_timer(0.1).timeout
	# Build the url to fetch
	var time: Dictionary = Time.get_date_dict_from_system()
	var date_string: String = "%04d-%02d-%02d" % [time.year, time.month, time.day]
	var url: String = "https://www.nytimes.com/svc/wordle/v2/%s.json" % date_string
	
	# Return the dayly Wordle word, and delete the http_requester
	var data: Variant = await http_requester.request(url)
	get_tree().root.remove_child(http_requester)
	if not data.has("solution"): return "NULL_WORD"
	print("The today's Wordle word is: %s" % data.solution)
	return data.solution
