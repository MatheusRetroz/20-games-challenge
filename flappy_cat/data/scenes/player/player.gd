extends CharacterBody2D
class_name Player


signal dead()
const GRAVITY: float = 2000.0
const JUMP_FORCE: float = 800.0

var size := Vector2(128.0, 128.0)
var is_init: bool = false
var is_dead: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# [NATIVE] -----------------------------------------------------------------------------------------
func _ready() -> void:
	animated_sprite.play("idle")
	await _run_init_animation()
	is_init = true

# --------------------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if not is_init: return
	if is_dead: return
	
	_process_gravity(delta)
	_process_input()
	_process_rotation()
	_check_position()
	
	move_and_slide()

# [PUBLIC] -----------------------------------------------------------------------------------------
func hit() -> void:
	is_dead = true
	dead.emit()
	
	rotation = 0.0
	velocity = Vector2.ZERO
	move_and_slide()
	
	animated_sprite.play("dead")
	_run_dead_animation()

# [PRIVATE] ----------------------------------------------------------------------------------------
func _process_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta

# --------------------------------------------------------------------------------------------------
func _process_input() -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_FORCE

# --------------------------------------------------------------------------------------------------
func _process_rotation() -> void:
	var new_rotation: float = lerpf(rotation_degrees, deg_to_rad(velocity.y * 1.5), 0.75)
	rotation_degrees = new_rotation

# --------------------------------------------------------------------------------------------------
func _check_position() -> void:
	if position.y < -size.y / 2.0: hit()
	elif position.y > get_viewport_rect().size.y: hit()

# --------------------------------------------------------------------------------------------------
func _run_init_animation() -> void:
	position.x = -size.x
	position.y = get_viewport_rect().size.y / 2.0
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", 256.0, 1.0)
	await tween.finished

# --------------------------------------------------------------------------------------------------
func _run_dead_animation() -> void:
	var offset: float = position.y - (size.y * (-1.0 if position.y < 0.0 else 1.0))
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position:y", offset, 0.5)
	tween.tween_property(self, "position:y", get_viewport_rect().size.y + size.y, 1.0)
