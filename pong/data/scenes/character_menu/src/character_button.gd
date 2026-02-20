extends TextureButton
class_name CharacterButton


# --- Export ---
@export var locked: bool = false: set = set_locked
@export var character_info: CharacterInfo = null
@export_group("Sprites")
@export var background_sprite: CanvasItem = null
@export var toggled_sprites: Array[Sprite2D] = []
@export var animation_sprites: Array[Sprite2D] = []

@export_group("Colors")
@export var hover_color := Color(0.5, 0.5, 0.5)
@export var disabled_color := Color(0.25, 0.25, 0.25, 1.0)
@export var toggled_color := Color(0.914, 0.322, 0.376, 1.0)

var _is_hover: bool = false

# ------ Init ------

func _ready() -> void:
	toggled.connect(_on_toggled)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	locked = locked

# ------ Funcs ------

func set_locked(value: bool) -> void:
	locked = value
	disabled = value
	_update_color()

func _update_color() -> void:
	if not background_sprite: return
	
	var color := Color.WHITE
	if disabled:
		color = disabled_color
	elif button_pressed:
		color = toggled_color
	elif _is_hover:
		color = hover_color
	
	background_sprite.self_modulate = color

func _animation_scale() -> void:
	for sprite: Sprite2D in animation_sprites:
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "scale", Vector2(1.1, 0.95), 0.1)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.5)

# ------ Signals ------

func _on_toggled(value: bool) -> void:
	for sprite: Sprite2D in toggled_sprites:
		sprite.visible = value
	
	if value:
		_animation_scale()
	_update_color()

func _on_mouse_entered() -> void:
	_is_hover = true
	_update_color()

func _on_mouse_exited() -> void:
	_is_hover = false
	_update_color()
