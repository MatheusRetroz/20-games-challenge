extends Node

# --- Camera ---
var camera: Camera2D = null

# --- Canvas ---
var transition_canvas: CanvasLayer = null
var border_canvas: CanvasLayer = null
var grain_canvas: CanvasLayer = null

# --- Effects ---
var border_effect: ShaderMaterial = preload("res://common/materials/canvas_border_material.tres")
var grain_effect: ShaderMaterial = preload("res://common/materials/grain_material.tres")

# ------ Init ------

func _enter_tree() -> void:
	camera = Camera2D.new()
	camera.offset.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2.0
	camera.offset.y = ProjectSettings.get_setting("display/window/size/viewport_height") / 2.0
	add_child(camera, true)
	
	transition_canvas = _get_canvas("TransitionCanvasLayer")
	border_canvas = _get_canvas("BorderCanvasLayer", 2)
	grain_canvas = _get_canvas("GrainCanvasLayer", 3)
	
	_add_effect(border_canvas, border_effect, "Border")
	_add_effect(grain_canvas, grain_effect, "Grain")

# ------ Funcs ------

func _add_effect(canvas: CanvasLayer, material: ShaderMaterial, title: String, index: int = 0) -> void:
	var color := ColorRect.new()
	color.name = title
	color.set_anchors_preset(Control.PRESET_FULL_RECT)
	color.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	color.material = material
	color.z_index = index
	canvas.add_child(color, true)

func _get_canvas(title: String, layer: int = 1) -> CanvasLayer:
	var canvas := CanvasLayer.new()
	canvas.name = title
	canvas.layer = layer
	add_child(canvas, true)
	return canvas
