extends CharacterBody2D
class_name Player


signal dead()
const GRAVITY: float = 2000.0
const JUMP_FORCE: float = 800.0

var size := Vector2(320.0, 320.0)
var floor_margin: float = 200.0

var is_init: bool = false
var is_dead: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_stream_player: AudioStreamPlayer = $JumpStreamPlayer
@onready var dead_stream_player: AudioStreamPlayer = $DeadStreamPlayer


# [NATIVE] -----------------------------------------------------------------------------------------
func _ready() -> void:
	position.x = -size.x
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)

# --------------------------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if is_dead or not is_init: return
	if event.is_action_pressed("jump"):
		animated_sprite.play("jump")
		jump_stream_player.play()
		velocity.y = -JUMP_FORCE

# --------------------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if not is_init: return
	if is_dead: return
	
	_process_gravity(delta)
	_process_rotation()
	_check_position()
	
	move_and_slide()

# [PUBLIC] -----------------------------------------------------------------------------------------
func init() -> void:
	await _run_init_animation()
	is_init = true

# --------------------------------------------------------------------------------------------------
func hit() -> void:
	is_dead = true
	dead.emit()
	
	rotation = 0.0
	velocity = Vector2.ZERO
	move_and_slide()
	
	dead_stream_player.play()
	animated_sprite.play("dead")
	_run_dead_animation()

# [PRIVATE] ----------------------------------------------------------------------------------------
func _process_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta

# --------------------------------------------------------------------------------------------------
func _process_rotation() -> void:
	var new_rotation: float = lerpf(rotation_degrees, deg_to_rad(velocity.y * 1.5), 0.75)
	rotation_degrees = new_rotation

# --------------------------------------------------------------------------------------------------
func _check_position() -> void:
	if position.y < -size.y / 2.0: hit()
	elif position.y > get_viewport_rect().size.y - floor_margin: hit()

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
	tween.parallel().tween_property(self, "rotation", deg_to_rad(90), 0.5).set_delay(0.25)
	tween.tween_property(self, "position:y", get_viewport_rect().size.y + size.y, 1.0)

# [SIGNAL] -----------------------------------------------------------------------------------------
func _on_animated_sprite_animation_finished() -> void:
	match animated_sprite.animation:
		"jump":
			animated_sprite.play("idle")
