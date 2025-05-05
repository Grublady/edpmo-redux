extends Area3D

const TRANS_TIME: float = 0.2

var movement_tween: Tween

@onready var initial_position := position
@onready var sprite: Sprite3D = $Sprite3D

func move_to(new_position: Vector3) -> void:
	if is_instance_valid(movement_tween):
		movement_tween.kill()
	movement_tween = create_tween()
	movement_tween.set_parallel()
	movement_tween.tween_method(_update_position, position, new_position, TRANS_TIME)

func _update_position(new_position: Vector3) -> void:
	position = new_position
	sprite.flip_h = (position.x < 0)
