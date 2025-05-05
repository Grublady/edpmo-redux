extends HBoxContainer

@onready var child_cards: Array[Node] = get_children()

func deselect_all() -> void:
	for card in child_cards:
		card.deselect()
