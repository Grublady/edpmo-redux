@tool
extends PanelContainer

@export var data: QuestData:
	set(new_value):
		if is_instance_valid(data):
			data.changed.disconnect(_update_data)
		data = new_value
		if is_instance_valid(data):
			data.changed.connect(_update_data)
		_update_data()

@onready var title_label: RichTextLabel = $VBoxContainer/Title/RichTextLabel
@onready var body_label: RichTextLabel = $VBoxContainer/Body/RichTextLabel

func _ready() -> void:
	_update_data()

func _update_data() -> void:
	if not is_instance_valid(data):
		return
	if is_instance_valid(title_label):
		title_label.text = data.title
	if is_instance_valid(body_label):
		body_label.text = data.description
