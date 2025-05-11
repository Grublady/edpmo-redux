extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var music: AudioStreamPlayer = $"Game Music"
@onready var overlay_bg: Node = $"Overlay BG"
@onready var quest_overlay: Control = $"Quest Overlay"
@onready var quest_timer: Timer = $"Quest Timer"

func _ready() -> void:
	hide_quests()

func show_quests() -> void:
	EventBus.game_focus.emit(EventBus.GameFocus.quests)

func hide_quests() -> void:
	EventBus.game_focus.emit(EventBus.GameFocus.game_board)
	
	quest_timer.stop()
	quest_timer.timeout.connect(show_quests, CONNECT_ONE_SHOT)
	quest_timer.start()

func _on_game_finished(player_wins: bool) -> void:
	if player_wins:
		get_tree().change_scene_to_file("res://scenes/game_win.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/game_lose.tscn")
