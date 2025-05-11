extends AudioStreamPlayer

const TRANS_TIME: float = 0.5

var tween: Tween

func _init() -> void:
	EventBus.game_focus.connect(_on_event_game_focus)

func _on_event_game_focus(event: EventBus.GameFocus) -> void:
	match event:
		EventBus.GameFocus.game_board:
			switch_to_variation(0)
		EventBus.GameFocus.quests:
			switch_to_variation(1)

func switch_to_variation(variation: int) -> void:
	var sync_streams := stream as AudioStreamSynchronized
	
	if is_instance_valid(tween):
		tween.kill()
	
	tween = create_tween()
	
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
			func(x): sync_streams.set_sync_stream_volume(variation, x),
			sync_streams.get_sync_stream_volume(variation),
			0.0,
			TRANS_TIME
	)
	
	tween.set_ease(Tween.EASE_IN)
	for i in sync_streams.stream_count:
		if i == variation:
			continue
		tween.tween_method(
				func(x): sync_streams.set_sync_stream_volume(i, x),
				sync_streams.get_sync_stream_volume(i),
				-60.0,
				TRANS_TIME
		)
