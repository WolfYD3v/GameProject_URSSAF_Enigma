extends QuestBookPage
class_name QuestBookPartGPage

@onready var label_2: Label = $Left/MarginContainer/Nodes/Label2

const DESCRIPTIONS: Dictionary[int, String] = {
	0: "Graves Minigame Not Initiated: Answer: 0",
	1: "Cristina Córdula would be proud of this person.",
	2: "He was kind of the team's workhorse. He took his duties very seriously.",
	3: "Everything was going well with that person, according to one of their acquaintances.",
	4: "That person wasn't who they seemed to be.",
	5: "His opinions were highly questionable, from the standpoint of good taste.",
	6: "His active adult lifestyle made him seem like someone everyone loved. Even to the person who wrote his profile.",
	7: "Filmed live, his expression was so funny that WolfY couldn't help but laugh when he saw the iconic image.",
	8: "He was hated by someone. He still is."
}

func _ready() -> void:
	if DESCRIPTIONS.has(SecretCodeManager.grave_part_nb):
		label_2.text = DESCRIPTIONS.get(SecretCodeManager.grave_part_nb)
