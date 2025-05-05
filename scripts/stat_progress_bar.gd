extends ProgressBar

func _init() -> void:
	changed.connect(_on_changed)
	_on_changed()

func _on_changed() -> void:
	modulate = lerp(Color.RED, Color.GREEN, (value - min_value) / (max_value - min_value))
