extends Node

signal secret_code_generated

const _HTTP_REQUESTER_PACKED_SCENE: PackedScene = preload("res://scenes/http_requester/http_requester.tscn")

var lenght_max: int = 100
var diego_rdm_number: int = 0
var pet_name: String = ""
var pet_name_reversed: bool = false
var counting_part_var: String = ""
var counting_part_text: String = ""
var counting_part_multiplier: int = 0
var grave_part_nb: int = 0
var wordle_two_text: String = ""
var math_safe_calcul: String = ""
var math_safe_calcul_answer: int = 0
var junk: String = ""

var schrodinger_cat_right_answer_value: int = 0

var _raw_secret_code: String = ""
var _encrypted_secret_code: String = ""

func _ready() -> void:
	pass

func generate() -> void:
	print("Generating code...\n")
	diego_rdm_number = randi_range(1, 9)
	print("The random number of Diego is: %d" % diego_rdm_number)
	_raw_secret_code = str(diego_rdm_number)
	
	# Setting/Adding a random pet name
	print("Petting cession...")
	_raw_secret_code += _set_random_pet_name()
	_raw_secret_code += _number_pet_name()
	
	# Setting the counting part
	print("Setting the counting part...")
	_raw_secret_code += await _set_counting_part()
	
	# Adding the value the morse text (TODO Morse Minigame On Quest Book)
	_raw_secret_code += "UNRANDOMSECTION"
	
	# Adding the Captcha answer
	print("Setting the Captcha...")
	CaptchatsData.set_random_captcha()
	print("The right answer of the Captcha is: %s" % CaptchatsData.right_answer)
	_raw_secret_code += CaptchatsData.right_answer
	
	# Adding the right grave idx (TODO Grave Minigame)
	grave_part_nb = randi_range(1, 8)
	_raw_secret_code += str(grave_part_nb)
	
	# Fetching the dayly Word of Wordle of today, and adds it in the secret code
	_raw_secret_code += await _get_wordle_dayly_word()
	
	# Adding a long random section (TODO Generation)
	_raw_secret_code += _set_wordle_two_word()
	
	# Adding Schrodinger's Cat answer
	schrodinger_cat_right_answer_value = randi_range(10000, 99999)
	_raw_secret_code += str(schrodinger_cat_right_answer_value)
	
	# Set The Safe Math Part
	_set_safe_math()
	
	# Filling the rest of the code with junk, to make it 100 characters if it is possible
	if _raw_secret_code.length() < lenght_max:
		print("Dumping junk in the code to make it very long (%d characters long)..." % lenght_max)
		var characters: String = Cryptographer.alphabetic_characters_list.to_lower() + Cryptographer.alphabetic_characters_list.to_upper() + Cryptographer.numbers_list + "()[]{}#&-|_,?;.:/!§"
		for _loop: int in range(lenght_max - _raw_secret_code.length()):
			junk += characters[randi_range(0, characters.length() - 1)]
		_raw_secret_code += junk
	
	# Encrypt the secret code
	Cryptographer.select_cryptography_mathods()
	_encrypted_secret_code = await Cryptographer.super_encrypt(_raw_secret_code)
	
	# The code is generated!
	await get_tree().create_timer(1.5).timeout
	secret_code_generated.emit()

func _set_random_pet_name() -> String:
	var selected_pet_name: String = ["Dog", "Cat"].pick_random()
	if randi_range(0, 1) == 1:
		pet_name_reversed = true
		selected_pet_name = selected_pet_name.reverse()
	
	pet_name = selected_pet_name
	return selected_pet_name

func _number_pet_name() -> String:
	var numbered_output: String = ""
	var idx: int = 1
	for pet_name_character: String in pet_name.to_lower():
		for letter: String in Cryptographer.alphabetic_characters_list:
			if pet_name_character == letter:
				numbered_output += str(idx)
				break
			idx += 1
		idx = 1
	
	return numbered_output

func _set_counting_part() -> String:
	if OS.get_name() == "Web": return "WordL".reverse()
	
	var output: String = ""
	# https://lorem-api.com/api/lorem?paragraphs=20
	
	# Add the http_requester
	var http_requester: HttpRequester = _create_http_requester()
	await get_tree().create_timer(0.1).timeout
	
	var random_paragraphs_count: int = randi_range(3, 10)
	var url: String = "https://lorem-api.com/api/lorem?paragraphs=%d" % random_paragraphs_count
	
	# pass
	var data: Variant = await http_requester.request(url)
	counting_part_text = data
	get_tree().root.remove_child(http_requester)
	if counting_part_text == "": return "NLI"
	var words_count: int = 0
	var current_word: String = ""
	for data_character: String in counting_part_text:
		if data_character in [" ", ",", ".", "(", ")", "!", "[", "]", "\n"] and current_word != "":
			words_count += 1
			current_word = ""
			continue
		current_word += data_character
	counting_part_multiplier = randi_range(20, 35)
	output = str(words_count * counting_part_multiplier)
	#output.remove_chars()
	if output.length() < 3: pass
	
	counting_part_var = output
	return output

func _set_wordle_two_word() -> String:
	var characters = Cryptographer.alphabetic_characters_list.to_upper()
	var lenght: int = characters.length() - 1
	wordle_two_text = ""
	for loop: int in range(20):
		wordle_two_text += characters[randi_range(0, lenght)]
	
	return wordle_two_text

func _set_safe_math() -> String:
	var safe_math_tokens: Array = _create_safe_math_token()
	print("Tokens: %s" % str(safe_math_tokens))
	
	# Format the tokens
	math_safe_calcul = _stringify_safe_math_tokens(safe_math_tokens)
	print("Operation: %s" % math_safe_calcul)
	
	var true_math_safe_calcul: String = _stringify_safe_math_tokens(safe_math_tokens, true)
	print("True Operation: %s" % true_math_safe_calcul)
	
	# Calculate the tokens
	var expression_object = Expression.new()
	var error = expression_object.parse(true_math_safe_calcul)
	if error == OK: math_safe_calcul_answer = expression_object.execute()
	else: print("Syntax Error In Math Expression")
	
	if math_safe_calcul_answer > 9: math_safe_calcul_answer = int(
		_stringify_safe_math_tokens([math_safe_calcul_answer], true)
	)
	return str(math_safe_calcul_answer)

func _create_safe_math_token() -> Array:
	var token: Array = []
	var allow_sub_tokens: bool = true
	if randi_range(0, 5) >= 4 and allow_sub_tokens: token.append(_create_safe_math_token()) # TK
	else: token.append(randi_range(1, 999)) # NB
	token.append(["+", "-", "*"].pick_random()) # OP
	if randi_range(0, 5) >= 4 and allow_sub_tokens: token.append(_create_safe_math_token()) # TK
	else: token.append(randi_range(1, 999)) # NB
	
	return token

func _stringify_safe_math_tokens(tokens: Array, short_numbers: bool = false) -> String:
	var output: String = ""
	var current_operator: String = ""
	for token: Variant in tokens:
		if token is int:
			if short_numbers:
				var str_number: String = str(token)
				if current_operator.is_empty() and tokens.size() > 2: current_operator = tokens[1]
				if str_number.length() > 1:
					while str_number.length() > 1:
						var result: String = ""
						for _str: String in str_number: result += "%s%s" % [_str, current_operator]
						result = result.erase(result.length() - 1)
						var expression_object = Expression.new()
						var error = expression_object.parse(result)
						if error == OK: str_number = str(expression_object.execute())
						else: print("Syntax Error In Math Expression")
						print("Curent str number: %s = %s" % [result, str_number])
				output += str_number
			else: output += str(token)
		if token is String:
			current_operator = token
			output += token
		if token is Array: output += "(%s)" % _stringify_safe_math_tokens(token, short_numbers)
	return output

func _get_wordle_dayly_word() -> String:
	if OS.get_name() == "Web": return "WordL".reverse()
	
	# Add the http_requester
	var http_requester: HttpRequester = _create_http_requester()
	await get_tree().create_timer(0.1).timeout
	
	# Build the url to fetch
	var time: Dictionary = Time.get_date_dict_from_system()
	var date_string: String = "%04d-%02d-%02d" % [time.year, time.month, time.day]
	var url: String = "https://www.nytimes.com/svc/wordle/v2/%s.json" % date_string
	
	# Return the dayly Wordle word, and delete the http_requester
	var data: Dictionary = JSON.parse_string(await http_requester.request(url))
	get_tree().root.remove_child(http_requester)
	if not data.has("solution"): return "EMPTY"
	print("The today's Wordle word is: %s" % data.solution)
	return data.solution

func _create_http_requester() -> HttpRequester:
	var http_requester: HttpRequester = _HTTP_REQUESTER_PACKED_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(http_requester)
	
	return http_requester
