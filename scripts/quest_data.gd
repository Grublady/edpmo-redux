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
