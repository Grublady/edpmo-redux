@tool
class_name QuestData extends Resource

@export var title: String = "":
	set(new_value):
		if new_value == title:
			return
		title = new_value
		emit_changed()

@export_multiline var description: String = "":
	set(new_value):
		if new_value == description:
			return
		description = new_value
		emit_changed()

@export_range(-10, 10, 1) var rations: float = 0
@export_range(-10, 10, 1) var peace: float = 0
@export_range(-10, 10, 1) var money: float = 0
@export_range(-10, 10, 1) var joy: float = 0
