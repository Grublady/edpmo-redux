extends Node

const TRANS_TIME: float = 0.25

@export var blur_amount: float = 1

@onready var vertical: ColorRect = $"Blur Vertical/ColorRect"
@onready var horizontal: ColorRect = $"Blur Horizontal/ColorRect"

var tween: Tween

var intensity: float = 0:
	set(new_value):
		intensity = new_value
		(vertical.material as ShaderMaterial).set_shader_parameter(&"amount", intensity * blur_amount)
		(horizontal.material as ShaderMaterial).set_shader_parameter(&"amount", intensity * blur_amount)

func _init() -> void:
	EventBus.game_focus.connect(_on_event_game_focus)

func _ready() -> void:
	intensity = intensity

func _on_event_game_focus(event: EventBus.GameFocus) -> void:
	match event:
		EventBus.GameFocus.game_board:
			exit_bg()
		EventBus.GameFocus.quests:
			enter_bg()

func enter_bg() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, ^"intensity", 1, TRANS_TIME)

func exit_bg() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, ^"intensity", 0, TRANS_TIME)
