extends Node

var cryptography_methods: Array[String] = [
	"cesar",
	"mono_alphabetic_substitution",
	"wolfy_numbers_offuscation",
	"suffled_base_64",
	"upper_lower_characters"
]
var _seleted_cryptography_methods: Array[String] = []
var alphabetic_characters_list: String = "abcdefghijklmnopqrstuvwxyz"
var alphabet_associations: Dictionary[String, String] = {}
var numbers_list: String = "0123456789"
var suffled_base_64_associations: Dictionary[int, int] = {}

func _ready() -> void:
	_select_cryptography_mathods()

func _select_cryptography_mathods() -> void:
	var temp_cryptography_methods: Array[String] = cryptography_methods.duplicate()
	var cryptography_method_picked: String = ""
	
	for loop: int in range(5):
		if temp_cryptography_methods.is_empty(): break
		cryptography_method_picked = temp_cryptography_methods.pick_random()
		temp_cryptography_methods.erase(cryptography_method_picked)
		_seleted_cryptography_methods.append(cryptography_method_picked)

func super_encrypt(text: String) -> String:
	print("\nEncrypting with %d method(s): %s ..." % [
		_seleted_cryptography_methods.size(), _seleted_cryptography_methods
	])
	var super_encrypted_text: String = text
	var cryptography_method_string: String = ""
	for cryptography_method: String in _seleted_cryptography_methods:
		print("Encryption method: %s" % cryptography_method)
		print("Data to encrypt: %s" % super_encrypted_text)
		cryptography_method_string = "_cryptography_method_%s" % cryptography_method
		if has_method(cryptography_method_string):
			super_encrypted_text = call(
				cryptography_method_string, super_encrypted_text
			)
		await get_tree().create_timer(0.5).timeout
	
	return super_encrypted_text

func _get_element_index_in_list(list: Variant, element: Variant) -> int:
	var idx: int = 0
	for current_list_element: Variant in list:
		if current_list_element == element: return idx
		idx += 1
	
	return -1

func _is_character_upper(character: String) -> bool:
	return RegEx.create_from_string(r"\p{Lu}").search(character) != null

func _create_alphabet_associations() -> void:
	print("Creating alphabet associations...")
	var idx: int = 0
	var temp_alphabetic_characters_list: String = alphabetic_characters_list
	alphabet_associations = {}
	
	for letter: String in alphabetic_characters_list:
		idx = randi_range(0, alphabetic_characters_list.length() - 1)
		alphabet_associations[letter] = temp_alphabetic_characters_list[idx]
		temp_alphabetic_characters_list.erase(idx)
	
	print("Alphabet associations generated: %s" % alphabet_associations)

#region cryptography_mathods
func _cryptography_method_cesar(text: String) -> String:
	var offset: int = SecretCodeManager.diego_rdm_number
	print("Encrypting with cesar with offset: %d (it was only based on Diego's attributed random number on startup)..." % offset)
	var cesar_text: String = ""
	var new_character_index: int = 0
	var alphabetic_characters_list_lenght: int = alphabetic_characters_list.length() - 1
	for text_character: String in text:
		var text_character_lower: String = text_character.to_lower()
		if text_character_lower in alphabetic_characters_list:
			new_character_index = _get_element_index_in_list(
				alphabetic_characters_list, text_character_lower
			) + offset
			if new_character_index > alphabetic_characters_list_lenght:
				new_character_index -= alphabetic_characters_list_lenght + 1
			# RegEx to find if the character is a uppercase
			if RegEx.create_from_string(r"\p{Lu}").search(text_character) != null:
				cesar_text += alphabetic_characters_list[new_character_index].to_upper()
			else: cesar_text += alphabetic_characters_list[new_character_index]
		else: cesar_text += text_character
	
	return cesar_text

func _cryptography_method_mono_alphabetic_substitution(text: String) -> String:
	print("Encrypting with mono-alphabetic substitution...")
	_create_alphabet_associations()
	var encrypted_text: String = ""
	
	for text_character: String in text:
		var lower_text_character: String = text_character.to_lower()
		
		if lower_text_character in alphabet_associations.keys():
			if _is_character_upper(text_character):
				encrypted_text += alphabet_associations[lower_text_character].to_upper()
			else: encrypted_text += alphabet_associations[text_character]
		else: encrypted_text += text_character
	
	return encrypted_text

func _cryptography_method_wolfy_numbers_offuscation(text: String) -> String:
	print("Encrypting with wolfy numbers offuscation...")
	var encrypted_text: String = ""
	var numbers_idxs: Dictionary = {}
	
	# Fill the 'numbers_idxs' Dictionnary
	var idx: int = 0
	for text_character: String in text:
		if text_character in numbers_list: numbers_idxs[idx] = int(text_character)
		idx += 1
	
	# Offuscate the numbers
	print("Numbers before offuscation: %s" % numbers_idxs)
	var numbers_size: int = numbers_idxs.size()
	var all_numbers: Array = numbers_idxs.values()
	var temp_numbers: Array = []
	var other_idx: int = 0
	for loop: int in range(numbers_size):
		if loop + 1 <= numbers_size - 1: other_idx = loop + 1
		else: other_idx = 0
		var temp_nb: int = all_numbers[loop] - all_numbers[other_idx]
		if temp_nb < 0: temp_nb = 9 + temp_nb
		temp_numbers.append(temp_nb)
	idx = 0
	for a: int in numbers_idxs.keys():
		numbers_idxs[a] = temp_numbers[idx]
		idx += 1
	print("Numbers after offuscation: %s" % numbers_idxs)
	
	# Write the output
	idx = 0
	for text_character: String in text:
		if idx in numbers_idxs.keys(): encrypted_text += str(numbers_idxs[idx])
		else: encrypted_text += text_character
		idx += 1
	
	return encrypted_text

func _cryptography_method_suffled_base_64(text: String) -> String:
	print("Encrypting with suffled base 64...")
	suffled_base_64_associations = {}
	var temp_encrypted_text: String = Marshalls.variant_to_base64(text)
	print("Encrypted text before suffling: %s" % temp_encrypted_text)
	var lenght: int = temp_encrypted_text.length()
	
	var encrypted_text: String = ""
	for loop: int in range(lenght):
		var random_idx: int = randi_range(0, temp_encrypted_text.length() - 1)
		encrypted_text += temp_encrypted_text[random_idx]
		temp_encrypted_text = temp_encrypted_text.erase(random_idx)
		
		suffled_base_64_associations[loop] = random_idx
	
	print("Suffling associations: %s" % suffled_base_64_associations)
	print("Encrypted text after suffling: %s" % encrypted_text)
	return encrypted_text

func _cryptography_method_upper_lower_characters(text: String) -> String:
	print("Encrypting with upper lower characters...")
	var encrypted_text: String = ""
	var characters_to_check: String = alphabetic_characters_list + alphabetic_characters_list.to_upper()
	
	for text_character: String in text:
		if text_character in characters_to_check:
			if _is_character_upper(text_character): encrypted_text += text_character.to_lower()
			else: encrypted_text += text_character.to_upper()
		else: encrypted_text += text_character
	
	return encrypted_text
#endregion
