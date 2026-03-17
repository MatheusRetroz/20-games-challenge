extends Node

## Singleton de gerenciamento de tela
## Controla os efeitos, câmera e gerencia as transições de tela


# ------------------------ CONSTS ------------------------

const SCREEN_SIZE := Vector2(1280.0, 720.0)

# ------------------------ VARS ------------------------

# Camera
var camera: Camera2D = null
# Canvas
var transition_canvas: CanvasLayer = null
var border_canvas: CanvasLayer = null
var grain_canvas: CanvasLayer = null
# Effect
var border_effect: ShaderMaterial = preload("res://common/materials/canvas_border_material.tres")
var grain_effect: ShaderMaterial = preload("res://common/materials/grain_material.tres")
var transition_effect: ShaderMaterial = preload("res://common/materials/transition_material.tres")
# Transition
var _transition_color: ColorRect = null
var _transition_tween: Tween = null


# ======================== INIT ========================

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	camera = Camera2D.new()
	camera.offset.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2.0
	camera.offset.y = ProjectSettings.get_setting("display/window/size/viewport_height") / 2.0
	add_child(camera, true)
	
	transition_canvas = _get_canvas("TransitionCanvasLayer",2)
	border_canvas = _get_canvas("BorderCanvasLayer", 3)
	grain_canvas = _get_canvas("GrainCanvasLayer", 4)
	
	_add_effect(border_canvas, border_effect, "Border")
	_add_effect(grain_canvas, grain_effect, "Grain")
	_transition_color = _add_effect(transition_canvas, transition_effect, "Transition")

# ======================== SET ========================

func set_transition(value: bool) -> void:
	if _transition_tween: return
	
	var mouse_filter := Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE
	var final_value: float = 1.0 if value else 0.0
	
	_transition_color.visible = true
	_transition_color.mouse_filter = mouse_filter
	
	_transition_tween = create_tween()
	_transition_tween.set_ease(Tween.EASE_IN)
	_transition_tween.set_trans(Tween.TRANS_QUAD)
	_transition_tween.tween_property(transition_effect, "shader_parameter/value", final_value, 1.0)
	await _transition_tween.finished
	
	_transition_tween = null
	_transition_color.visible = value

func in_transition() -> bool:
	return _transition_tween != null

# ======================== PRIVATE FUNCS ========================

func _add_effect(canvas: CanvasLayer, material: ShaderMaterial, title: String, index: int = 0) -> ColorRect:
	var color := ColorRect.new()
	color.name = title
	color.set_anchors_preset(Control.PRESET_FULL_RECT)
	color.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	color.material = material
	color.z_index = index
	canvas.add_child(color, true)
	return color

func _get_canvas(title: String, layer: int = 1) -> CanvasLayer:
	var canvas := CanvasLayer.new()
	canvas.name = title
	canvas.layer = layer
	add_child(canvas, true)
	return canvas
