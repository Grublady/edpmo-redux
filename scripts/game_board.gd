extends Sprite3D

const TOTAL_SPACE_COUNT: int = 44
const SPACE_DISTANCE: float = 0.07
const FIRST_SPACE := Vector3(0, 0, 0.35) + (SPACE_DISTANCE * Vector3.LEFT)

var is_player_turn: bool = false:
	set(new_value):
		if new_value == is_player_turn:
			return
		is_player_turn = new_value
		die.active = is_player_turn
		if is_player_turn:
			die.roll_finished.connect(_on_die_roll_finished, CONNECT_ONE_SHOT)

var rolled_value: int = -1

var pawn_positions_blue: Array[int] = [
	-1,
	-1,
	-1,
	-1,
]
var pawn_positions_red: Array[int] = [
	-1,
	-1,
	-1,
	-1,
]

@onready var pawns_blue: Array[CollisionObject3D] = [
	$"Pawn (Blue) 1",
	$"Pawn (Blue) 2",
	$"Pawn (Blue) 3",
	$"Pawn (Blue) 4",
]
@onready var pawns_red: Array[CollisionObject3D] = [
	$"Pawn (Red) 1",
	$"Pawn (Red) 2",
	$"Pawn (Red) 3",
	$"Pawn (Red) 4",
]

@onready var die: Node3D = $Die
@onready var opponent_timer: Timer = $"Opponent Timer"

func _ready() -> void:
	for i in pawns_blue.size():
		pawns_blue[i].input_event.connect(_on_player_pawn_input_event.bind(i))
	if not is_player_turn:
		move(0, 1)

func _on_die_roll_finished(value: int) -> void:
	rolled_value = value

func _on_player_pawn_input_event(
	_camera: Node,
	event: InputEvent,
	_event_position: Vector3,
	_normal: Vector3,
	_shape_idx: int,
	pawn: int
) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if is_player_turn and rolled_value != -1:
			if move(pawn, rolled_value):
				rolled_value = -1
				opponent_timer.stop()
				opponent_timer.timeout.connect(_opponent_move, CONNECT_ONE_SHOT)
				opponent_timer.start()

func lookup_board_space_position(space: int) -> Vector3:
	return (
			FIRST_SPACE
			
			+ SPACE_DISTANCE * (clampi(space - 0, 0, 4)) * Vector3.FORWARD
			+ SPACE_DISTANCE * (clampi(space - 4, 0, 4)) * Vector3.LEFT
			+ SPACE_DISTANCE * (clampi(space - 8, 0, 2)) * Vector3.FORWARD
			+ SPACE_DISTANCE * (clampi(space - 10, 0, 4)) * Vector3.RIGHT
			+ SPACE_DISTANCE * (clampi(space - 14, 0, 4)) * Vector3.FORWARD
			+ SPACE_DISTANCE * (clampi(space - 18, 0, 2)) * Vector3.RIGHT
			
			+ SPACE_DISTANCE * (clampi(space - 20, 0, 4)) * Vector3.BACK
			+ SPACE_DISTANCE * (clampi(space - 24, 0, 4)) * Vector3.RIGHT
			+ SPACE_DISTANCE * (clampi(space - 28, 0, 2)) * Vector3.BACK
			+ SPACE_DISTANCE * (clampi(space - 30, 0, 4)) * Vector3.LEFT
			+ SPACE_DISTANCE * (clampi(space - 34, 0, 4)) * Vector3.BACK
			+ SPACE_DISTANCE * (clampi(space - 38, 0, 1)) * Vector3.LEFT
			
			+ SPACE_DISTANCE * (clampi(space - 39, 0, 4)) * Vector3.FORWARD
	)

## Attempts to perform the specified move
## and returns a bool indicating if it was successful.
func move(pawn: int, roll: int) -> bool:
	var pawn_positions: Array[int]
	var pawn_node: Node3D
	if is_player_turn:
		pawn_positions = pawn_positions_blue
		pawn_node = pawns_blue[pawn]
	else:
		pawn_positions = pawn_positions_red
		pawn_node = pawns_red[pawn]
	
	if pawn_positions[pawn] + roll >= TOTAL_SPACE_COUNT:
		return false
	
	pawn_positions[pawn] += roll
	
	if is_player_turn:
		pawn_node.position = lookup_board_space_position(pawn_positions[pawn])
	else:
		pawn_node.position = lookup_board_space_position(pawn_positions[pawn]).rotated(Vector3.UP, PI)
	
	is_player_turn = not is_player_turn
	return true

func _opponent_move() -> void:
	move(1, randi_range(1, 5))
