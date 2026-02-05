extends Node2D

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var min_motion := Vector2(-50.0, -50.0)
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var max_motion := Vector2(50.0, 50.0)
@export var nodes: Dictionary[CanvasItem, float] = {}

func _process(delta: float) -> void:
	for node: CanvasItem in nodes.keys():
		if node:
			var motion: Vector2 = get_global_mouse_position() * nodes[node] * delta
			motion = motion.clamp(min_motion, max_motion)
			node.position += motion - node.position
