extends CharacterBody2D


# ------------------------ EXPORT ------------------------

@export_group("Speed")
@export var min_speed: float = 400.0
@export var max_speed: float = 800.0
@export var step_speed: float = 20.0

@export_group("Shadow")
@export var shadow_offset: float = 32.0
@export var shadow_speed: float = 10.0

# ------------------------ CONSTS ------------------------

const TRAIL_FADE_DURATION: float = 1.0
const TRAIL_BOOST_COUNT: int = 20
const SPEED_BOOST_FACTOR: float = 1.25

const SPRITE_SCALE := Vector2(0.75, 0.75)
const SPRITE_BOOST_SCALE := Vector2(0.75, 1.25) 
const SPRITE_BOOST_DURATION: float = 2.0

# ------------------------ ONREADY ------------------------

@onready var sprite: Sprite2D = $Sprite
@onready var trail_line: Line2D = $Trail
@onready var shadow_sprite: Sprite2D = $Shadow
@onready var collision_player: AudioStreamPlayer = $CollisionPlayer
@onready var paddle_player: AudioStreamPlayer = $PaddlePlayer

# ------------------------ VARS ------------------------

# Movement
var current_direction := Vector2.ZERO
var current_speed: float = 0.0
var base_speed: float = 0.0
# Trail
var trail_length: int = 0
var trail_tween: Tween = null


# ======================== INIT ========================

func _ready() -> void:
	base_speed = min_speed
	current_speed = min_speed
	_reset_visuals()

# ======================== PROCESS ========================

func _physics_process(delta: float) -> void:
	if current_direction == Vector2.ZERO:
		return
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		_handle_collision(collision)
	
	velocity = current_direction * current_speed
	sprite.rotation = current_direction.angle() + deg_to_rad(90)
	_update_trail()
	_update_shadow(delta)

# ======================== PUBLIC FUNCS ========================

func update_direction(value: Vector2) -> void:
	_stop_trail_tween()
	_play_paddle_sound()
	_play_animation_scale()
	
	current_direction = value
	current_speed = base_speed * SPEED_BOOST_FACTOR
	trail_length = TRAIL_BOOST_COUNT
	
	await _play_trail_tween()
	
	trail_tween = null
	base_speed = _clamped_speed(base_speed + step_speed)

func reset(new_position: Vector2) -> void:
	_stop_trail_tween()
	_reset_visuals()
	
	global_position = new_position
	current_direction = Vector2.ZERO
	current_speed = min_speed
	base_speed = min_speed
	velocity = Vector2.ZERO
	move_and_slide()

# ======================== PRIVATE FUNCS ========================

func _handle_collision(collision: KinematicCollision2D) -> void:
	if not trail_tween:
		base_speed = _clamped_speed(base_speed + step_speed)
		current_speed = base_speed
		
	collision_player.play()
	current_direction = velocity.bounce(collision.get_normal()).normalized()

func _update_trail() -> void:
	if trail_length > 0:
		trail_line.add_point(trail_line.to_local(global_position))
	while trail_line.get_point_count() > trail_length:
		trail_line.remove_point(0)

func _update_shadow(delta: float) -> void:
	var center_size: float = (ScreenManager.SCREEN_SIZE.x / 2.0)
	var offset: float = 1.0 - abs((global_position.x - center_size) / center_size)
	
	shadow_sprite.visible = true
	shadow_sprite.position.y = lerpf(
		shadow_sprite.position.y, 
		shadow_offset + (shadow_offset * offset), 
		shadow_speed * delta
	)

func _play_trail_tween() -> Signal:
	trail_tween = create_tween()
	trail_tween.tween_property(self, "trail_length", 0, TRAIL_FADE_DURATION)
	trail_tween.parallel().tween_property(self, "current_speed", base_speed, TRAIL_FADE_DURATION)
	return trail_tween.finished

func _stop_trail_tween() -> void:
	if trail_tween and trail_tween.is_running():
		trail_tween.kill()

func _play_animation_scale() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", SPRITE_BOOST_SCALE, 0.1)
	tween.tween_property(sprite, "scale", SPRITE_SCALE, SPRITE_BOOST_DURATION)

func _play_paddle_sound() -> void:
	if not paddle_player.playing:
		paddle_player.play()

func _reset_visuals() -> void:
	shadow_sprite.visible = false
	trail_line.clear_points()

func _clamped_speed(value: float) -> float:
	return min(value, max_speed)
