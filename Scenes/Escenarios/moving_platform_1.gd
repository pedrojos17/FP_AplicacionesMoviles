extends AnimatableBody2D

func _process(delta: float) -> void:
	global_position = get_parent().global_position
