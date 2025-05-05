@tool
extends HBoxContainer

@export var stat_name: String:
	set(new_value):
		stat_name = new_value
		if get_child_count() == 0:
			return
		$RichTextLabel.text = stat_name

@export_range(0, 1, 0.01) var value: float:
	set(new_value):
		value = new_value
		if get_child_count() == 0:
			return
		$MarginContainer/ProgressBar.value = 100 * value

func _ready() -> void:
	$RichTextLabel.text = stat_name
	$MarginContainer/ProgressBar.value = 100 * value
