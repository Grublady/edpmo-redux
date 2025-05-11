extends Camera3D

const TRANS_TIME: float = 0.25

@onready var quaternion_a := quaternion
@onready var quaternion_b := Quaternion(Vector3.UP, -PI/3) * quaternion

var tween: Tween
var focus: float:
	set(new_value):
		focus = new_value
		quaternion = quaternion_a.slerp(quaternion_b, focus)

func _init() -> void:
	EventBus.game_focus.connect(_on_event_game_focus)

func _on_event_game_focus(event: EventBus.GameFocus) -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_QUAD)
	
	match event:
		EventBus.GameFocus.game_board:
			tween.tween_property(self, ^"focus", 0, TRANS_TIME)
			tween.tween_property(self, ^"fov", 60, TRANS_TIME)
		EventBus.GameFocus.quests:
			tween.tween_property(self, ^"focus", 1, TRANS_TIME)
			tween.tween_property(self, ^"fov", 90, TRANS_TIME)
