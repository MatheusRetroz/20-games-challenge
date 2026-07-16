extends Parallax2D
class_name AutoParallax


const DEFAULT_SPEED: float = -500.0
static var speed: float = DEFAULT_SPEED

@export var unique: bool = false


# --------------------------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	var value: float = DEFAULT_SPEED if unique else speed
	if value != autoscroll.x:
		autoscroll.x = value * scroll_scale.x
