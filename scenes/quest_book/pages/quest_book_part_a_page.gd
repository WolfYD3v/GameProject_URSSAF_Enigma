extends QuestBookPage
class_name QuestBookPartAPage

@onready var pet_texture_rect: TextureRect = $Right/MarginContainer/Nodes/PetTextureRect

const PET_TEXTURES: Dictionary[String, String] = {
	"Dog": "res://assets/textures/quest_book_encouragments/quest_book_dog.jpg",
	"Cat": "res://assets/textures/quest_book_encouragments/quest_book_cat.jpg"
}

func _ready() -> void:
	var pet_name: String = SecretCodeManager.pet_name
	if pet_name.is_empty(): return
	
	if SecretCodeManager.pet_name_reversed:
		pet_texture_rect.flip_h = true
		pet_name = pet_name.reverse()
	pet_texture_rect.texture = load(PET_TEXTURES.get(pet_name))
