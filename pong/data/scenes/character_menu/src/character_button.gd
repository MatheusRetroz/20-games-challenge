extends TextureButton
class_name CharacterButton


# ------------------------ EXPORT ------------------------

@export var character_type := CharacterInfo.CharacterType.NONE
@export var name_label: Label = null

@export_group("Sprites")
@export var background_sprite: CanvasItem = null
@export var toggled_sprites: Array[Sprite2D] = []
@export var animation_sprites: Array[Sprite2D] = []

@export_group("Colors")
@export var hover_color := Color(0.5, 0.5, 0.5)
@export var disabled_color := Color(0.25, 0.25, 0.25, 1.0)
@export var toggled_color := Color(0.914, 0.322, 0.376, 1.0)
@export var disabled_sprite_color := Color(0.039, 0.039, 0.039, 1.0)

# ------------------------ CONSTS ------------------------

const SPRITE_SCALE := Vector2.ONE
const SPRITE_PRESSED_SCALE := Vector2(1.1, 0.95)
const SPRITE_SCALE_DURATION: float = 0.5

# ------------------------ VARS ------------------------

var character_info: CharacterInfo = null
var _is_hover: bool = false


# ======================== INIT ========================

func _ready() -> void:
	toggled.connect(_on_toggled)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	
	match character_type:
		CharacterInfo.CAT:
			character_info = CharacterInfo.cat_resource
		CharacterInfo.CUCUMBER:
			character_info = CharacterInfo.cucumber_resource
	
	_check_character_info()

# ======================== PRIVATE FUNCS ========================

func _check_character_info() -> void:
	if character_info:
		disabled = character_info.locked
		_update_color()
		_update_name()

func _update_color() -> void:
	if not background_sprite: return
	
	var color := Color.WHITE
	var sprite_color := Color.WHITE
	if disabled:
		color = disabled_color
		sprite_color = disabled_sprite_color
	elif button_pressed:
		color = toggled_color
	elif _is_hover:
		color = hover_color
	
	background_sprite.self_modulate = color
	for sprite: Sprite2D in animation_sprites:
		sprite.modulate = sprite_color


func _update_name() -> void:
	if not name_label: return
	if not character_info: return
	
	if character_info.locked:
		name_label.text = character_info.locked_name
	else:
		name_label.text = character_info.name

func _animation_scale() -> void:
	if not button_pressed: return
	for sprite: Sprite2D in animation_sprites:
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "scale", SPRITE_PRESSED_SCALE, 0.1)
		tween.tween_property(sprite, "scale", SPRITE_SCALE, SPRITE_SCALE_DURATION)

# ======================== SIGNALS ========================

func _on_toggled(value: bool) -> void:
	for sprite: Sprite2D in toggled_sprites:
		sprite.visible = value
	
	_animation_scale()
	_update_color()

func _on_mouse_entered() -> void:
	_is_hover = true
	_update_color()

func _on_mouse_exited() -> void:
	_is_hover = false
	_update_color()
