extends Area3D

var active: bool = false:
	set(new_value):
		active = new_value
		if active:
			$Sprite3D.modulate = Color.WHITE
			$Label3D.modulate = Color.WHITE
		else:
			$Sprite3D.modulate = Color(1, 1, 1, 0.8)
			$Label3D.modulate = Color(0.8, 0.8, 0.8, 0.8)

func _ready() -> void:
	active = active
