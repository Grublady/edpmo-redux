extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var music: AudioStreamPlayer = $"Game Music"
@onready var overlay_bg: Node = $"Overlay BG"
@onready var quest_overlay: Control = $"Quest Overlay"
@onready var quest_timer: Timer = $"Quest Timer"

func _ready() -> void:
	hide_quests()

func show_quests() -> void:
	camera.focus_quests()
	music.switch_to_variation(1)
	overlay_bg.enter_bg()
	quest_overlay.enter_view()

func hide_quests() -> void:
	camera.focus_boardgame()
	music.switch_to_variation(0)
	overlay_bg.exit_bg()
	quest_overlay.exit_view()
	
	quest_timer.stop()
	quest_timer.timeout.connect(show_quests, CONNECT_ONE_SHOT)
	quest_timer.start()

func _on_game_finished(player_wins: bool) -> void:
	if player_wins:
		get_tree().change_scene_to_file("res://scenes/game_win.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/game_lose.tscn")
