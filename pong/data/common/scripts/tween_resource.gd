@tool extends Resource
class_name TweenResource

@export var value: Variant
@export var duration: float = 1.0
@export var property: String = ""
@export var ease_type := Tween.EaseType.EASE_IN
@export var trans_type := Tween.TransitionType.TRANS_BACK
var _tween: Tween = null


func run_tween(node: Node) -> void:
	if _tween.is_running(): _tween.kill()
	
	_tween = node.create_tween()
	_tween.set_ease(ease_type)
	_tween.set_trans(trans_type)
	_tween.tween_property(node, property, value, duration)
	await _tween.finished
