extends Sprite3D

signal game_finished(player_wins: bool)

const TOTAL_SPACE_COUNT: int = 44
const PAWNS_PER_PLAYER: int = 4
const SPACE_DISTANCE: float = 0.07
const FIRST_SPACE := Vector3(0, 0, 0.35) + (SPACE_DISTANCE * Vector3.LEFT)

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

var rolled_value: int = -1

var _is_player_turn: bool = true

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

@onready var player_die: Node3D = $"Player Die"
@onready var opponent_die: Node3D = $"Opponent Die"
@onready var pass_button: Area3D = $"Pass Button"
@onready var opponent_timer: Timer = $"Opponent Timer"

func _ready() -> void:
	pass_button.input_event.connect(_on_pass_button_input_event)
	for i in pawns_blue.size():
		pawns_blue[i].input_event.connect(_on_player_pawn_input_event.bind(i))
	pass_turn(true)

func _on_die_roll_finished(value: int) -> void:
	rolled_value = value
	if is_player_turn():
		pass_button.active = true

func _on_pass_button_input_event(
	_camera: Node,
	event: InputEvent,
	_event_position: Vector3,
	_normal: Vector3,
	_shape_idx: int,
) -> void:
	if not is_player_turn() or rolled_value == -1:
		return
	if event is InputEventMouseButton and event.is_pressed():
		pass_turn(false)

func _on_player_pawn_input_event(
	_camera: Node,
	event: InputEvent,
	_event_position: Vector3,
	_normal: Vector3,
	_shape_idx: int,
	pawn: int
) -> void:
	if not is_player_turn() or rolled_value == -1:
		return
	if event is InputEventMouseButton and event.is_pressed():
		try_move(pawn, rolled_value)

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
func try_move(pawn: int, roll: int) -> bool:
	var pawn_positions: Array[int]
	var pawn_node: Node3D
	if is_player_turn():
		pawn_positions = pawn_positions_blue
		pawn_node = pawns_blue[pawn]
	else:
		pawn_positions = pawn_positions_red
		pawn_node = pawns_red[pawn]
	
	var pos := pawn_positions[pawn]
	
	if pos == -1 and roll != 6:
		return false
	
	if pos + roll >= TOTAL_SPACE_COUNT:
		return false
	
	for i in pawn_positions.size():
		if i == pawn:
			continue
		if pawn_positions[i] == pos + roll:
			return false
	
	if pos == -1:
		pawn_positions[pawn] = 0
	else:
		pawn_positions[pawn] += roll
	
	_check_bump(pawn_positions[pawn])
	
	if is_player_turn():
		pawn_node.move_to(lookup_board_space_position(pawn_positions[pawn]))
	else:
		pawn_node.move_to(lookup_board_space_position(pawn_positions[pawn]).rotated(Vector3.UP, PI))
	
	if pawn_positions_blue.all(space_is_home):
		game_finished.emit(true)
	elif pawn_positions_red.all(space_is_home):
		game_finished.emit(false)
	else:
		pass_turn()
	
	return true

func pass_turn(to_player: bool = not _is_player_turn) -> void:
	_is_player_turn = to_player

	rolled_value = -1
	player_die.active = _is_player_turn
	opponent_die.active = not _is_player_turn

	if _is_player_turn:
		player_die.roll_finished.connect(_on_die_roll_finished, CONNECT_ONE_SHOT)
	else:
		pass_button.active = false
		opponent_timer.stop()
		opponent_timer.timeout.connect(_opponent_move, CONNECT_ONE_SHOT)
		opponent_timer.start()
		opponent_die.roll_finished.connect(_on_die_roll_finished, CONNECT_ONE_SHOT)

func is_player_turn() -> bool:
	return _is_player_turn

func space_is_home(space: int) -> bool:
	return space > (TOTAL_SPACE_COUNT - 1 - PAWNS_PER_PLAYER)

func _check_bump(at_space: int) -> void:
	if at_space >= 40:
		# Home zone
		return

	var other_player_pawn_positions: Array[int]
	if is_player_turn():
		other_player_pawn_positions = pawn_positions_red
	else:
		other_player_pawn_positions = pawn_positions_blue

	var transformed_space := (at_space + 20) % 40
	var bumped_pawn := other_player_pawn_positions.find(transformed_space)

	if bumped_pawn == -1:
		return

	other_player_pawn_positions[bumped_pawn] = -1
	var pawns: Array[CollisionObject3D]
	if is_player_turn():
		pawns = pawns_red
	else:
		pawns = pawns_blue
	pawns[bumped_pawn].move_to(pawns[bumped_pawn].initial_position)

func _opponent_move() -> void:
	opponent_die.start_roll()
	await opponent_die.roll_finished
	opponent_timer.stop()
	opponent_timer.start()
	await opponent_timer.timeout
	var pawn_pref := range(pawns_red.size())
	pawn_pref.shuffle()
	for pawn in pawn_pref:
		if try_move(pawn, rolled_value):
			return
	pass_turn(true)
