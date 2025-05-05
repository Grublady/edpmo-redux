@tool
extends TextureRect

signal selected(data: QuestData)

@export var data: QuestData:
	set(new_value):
		if is_instance_valid(data):
			data.changed.disconnect(_update_data)
		data = new_value
		if is_instance_valid(data):
			data.changed.connect(_update_data)
		_update_data()

@onready var title_label: RichTextLabel = $Title
@onready var body_label: RichTextLabel = $Body

func _ready() -> void:
	_update_data()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_viewport().set_input_as_handled()
		select()

func _update_data() -> void:
	if not is_instance_valid(data):
		return
	if is_instance_valid(title_label):
		title_label.text = data.title
	if is_instance_valid(body_label):
		body_label.text = data.description

func select() -> void:
	selected.emit(data)
	texture = ResourceLoader.load("res://sprites/ui/cardselected.png")

func deselect() -> void:
	texture = ResourceLoader.load("res://sprites/ui/card.png")
