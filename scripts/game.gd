extends Node3D

@onready var music: AudioStreamPlayer = $"Game Music"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_left"):
		get_viewport().set_input_as_handled()
		music.switch_to_variation(0)
	elif event.is_action_pressed(&"ui_right"):
		get_viewport().set_input_as_handled()
		music.switch_to_variation(1)
