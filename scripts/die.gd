extends Area3D

signal roll_finished(value: int)

@export var roll_duration: float = 0.5
@export var rolling_frame_time: float = 0.075

var rolling_elapsed: float = -1
var active: bool = false:
	set(new_value):
		if new_value == active:
			return
		active = new_value
		_update_modulate()
var has_mouse: bool = false:
	set(new_value):
		if new_value == has_mouse:
			return
		has_mouse = new_value
		_update_modulate()

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _init() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _ready() -> void:
	_update_modulate()

func _process(delta: float) -> void:
	if rolling_elapsed >= 0 && rolling_elapsed < roll_duration:
		var prev_elapsed_frames := floorf(rolling_elapsed / rolling_frame_time)
		rolling_elapsed += delta
		var current_elapsed_frames := floorf(rolling_elapsed / rolling_frame_time)
		if current_elapsed_frames > prev_elapsed_frames:
			var new_frame := randi_range(1, 5) - 1
			if new_frame >= sprite.frame:
				# Don't show the same frame twice in a row
				new_frame += 1
			sprite.frame = (new_frame)
	elif rolling_elapsed >= roll_duration:
		rolling_elapsed = -1
		var result := randi_range(1, 6)
		sprite.frame = result - 1
		roll_finished.emit(result)
		active = false

func _input_event(
	_camera: Camera3D,
	event: InputEvent,
	_event_position: Vector3,
	_normal: Vector3,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if active and (rolling_elapsed == -1):
			start_roll()

func _on_mouse_entered() -> void:
	has_mouse = true

func _on_mouse_exited() -> void:
	has_mouse = false

func start_roll() -> void:
	rolling_elapsed = 0
	_update_modulate()

func _update_modulate() -> void:
	if active:
		if has_mouse and (rolling_elapsed == -1):
			sprite.modulate = Color(0.8, 0.8, 0.8)
		else:
			sprite.modulate = Color.WHITE
	else:
		sprite.modulate = Color(0.6, 0.6, 0.6)
