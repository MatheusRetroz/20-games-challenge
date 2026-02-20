extends Node2D

@export var motion_speed: float = 10.0
@export_category("Motion Range")
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var min_motion := Vector2(-50.0, -50.0)
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var max_motion := Vector2(50.0, 50.0)
@export var nodes: Dictionary[CanvasItem, float] = {}

func _process(delta: float) -> void:
	for node: CanvasItem in nodes.keys():
		if node:
			var motion: Vector2 = node.get_local_mouse_position() * nodes[node] * delta
			motion = motion.clamp(min_motion, max_motion) - node.position
			node.position = lerp(node.position, node.position + motion, delta * motion_speed)
