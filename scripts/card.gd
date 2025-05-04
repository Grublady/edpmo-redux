@tool
extends PanelContainer

@export var title: String:
	set(new_value):
		title = new_value
		if is_instance_valid(title_label):
			title_label.text = title

@export_multiline var body: String:
	set(new_value):
		body = new_value
		if is_instance_valid(body_label):
			body_label.text = body

@onready var title_label: RichTextLabel = $VBoxContainer/Title/RichTextLabel
@onready var body_label: RichTextLabel = $VBoxContainer/Body/RichTextLabel

func _ready() -> void:
	title_label.text = title
	body_label.text = body
