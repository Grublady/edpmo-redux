extends MarginContainer

const BPM: float = 120
const DANCE_AMOUNT: int = 10

@export var music_player: AudioStreamPlayer

func _process(_delta: float) -> void:
	if is_instance_valid(music_player):
		var time := music_player.get_playback_position() + AudioServer.get_time_since_last_mix()
		var beat := floorf(time / BPM * 60 * 4)
		begin_bulk_theme_override()
		if fmod(beat, 2) == 0:
			add_theme_constant_override(&"margin_top", DANCE_AMOUNT)
			add_theme_constant_override(&"margin_bottom", 0)
		else:
			add_theme_constant_override(&"margin_top", 0)
			add_theme_constant_override(&"margin_bottom", DANCE_AMOUNT)
		end_bulk_theme_override()
