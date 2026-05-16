extends Node

func _ready() -> void:
	pass

func to_bin(int_input: int) -> Array:
	var bin_output: Array = []
	var minus_value: int = 128
	
	for loop: int in range(8):
		if int_input - minus_value < 0: bin_output.append(0)
		else:
			int_input -= minus_value
			bin_output.append(1)
		minus_value /= 2
	
	return bin_output

func to_hex(bin_input: Array) -> int:
	var int_output: int = 0
	var add_value: int = 128
	
	for bin_element: int in bin_input:
		if bin_element == 1: int_output += add_value
		add_value /= 2
	
	return int_output
