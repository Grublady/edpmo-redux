extends Node

@warning_ignore("unused_signal")
signal game_focus(event: GameFocus)
enum GameFocus {
	game_board,
	quests,
}
