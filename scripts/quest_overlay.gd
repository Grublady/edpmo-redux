extends Control

const ENTER_TIME: float = 0.25
const EXIT_TIME: float = 0.5

var tween: Tween

func _ready() -> void:
	position = Vector2(size.x, 0)
	hide()

func enter_view() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(true)
	tween.tween_property(self, ^"position", Vector2.ZERO, ENTER_TIME)
	tween.tween_property(self, ^"modulate", Color.WHITE, ENTER_TIME)
	
	show()

func exit_view() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(true)
	tween.tween_property(self, ^"position", Vector2(size.x, 0), EXIT_TIME)
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, EXIT_TIME)
	
	tween.set_parallel(false)
	tween.tween_callback(hide)
