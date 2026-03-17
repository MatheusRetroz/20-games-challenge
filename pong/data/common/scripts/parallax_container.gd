@tool extends Node2D
class_name ParallaxContainer

## Nó 2D que aplica um efeito de parallax em qualquer [CanvasItem]
## com base na posição do mouse em relação ao centro da viewport.

## Cada [CanvasItem] registrado no dicionário [layers] se move suavemente
## dentro dos limites definidos port [negative_motion] e [positive_motion],
## com velocidade de resposta controlado por [follow_speed].

## Sei que a Godot possui ótimos nodes de Parallax porem resolvi criar esse pois
## queria ter mais controle em relação ao movimento.


# ------------------------ EXPORT ------------------------

@export var layers: Dictionary[CanvasItem, float] = {}
@export_category("Motion")
@export var follow_speed: float = 1.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var negative_motion := Vector2(-50.0, -50.0):
	set(value):
		negative_motion = value.min(Vector2.ZERO)
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var positive_motion := Vector2(50.0, 50.0):
	set(value):
		positive_motion = value.max(Vector2.ZERO)


# ======================== PROCESS ========================

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var mouse_offset: Vector2 = _get_mouse_offset()
	var motion_range: Vector2 = abs(negative_motion) + positive_motion
	
	for layer: CanvasItem in layers.keys():
		var motion: Vector2 = motion_range * (mouse_offset * layers[layer])
		motion = motion.clamp(negative_motion, positive_motion) - layer.position
		layer.position = lerp(layer.position, layer.position + motion, delta * follow_speed)

# ======================== PRIVATE FUNCS ========================

func _get_mouse_offset() -> Vector2:
	var viewport_center: Vector2 = ScreenManager.SCREEN_SIZE / 2.0
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_offset: Vector2 = (mouse_pos - viewport_center) / viewport_center
	mouse_offset.x = clampf(mouse_offset.x, -1.0, 1.0)
	mouse_offset.y = clampf(mouse_offset.y, -1.0, 1.0)
	return mouse_offset
