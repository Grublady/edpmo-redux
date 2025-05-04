extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var music: AudioStreamPlayer = $"Game Music"
@onready var quest_overlay: Control = $"Quest Overlay"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_left"):
		get_viewport().set_input_as_handled()
		camera.focus_boardgame()
		music.switch_to_variation(0)
		quest_overlay.exit_view()
	elif event.is_action_pressed(&"ui_right"):
		get_viewport().set_input_as_handled()
		camera.focus_quests()
		music.switch_to_variation(1)
		quest_overlay.enter_view()
