extends CharacterBody2D
class_name Character

## Um CharacterBody2D com as principais funções e propriedades para o funcionamento dos personagens!
## Vejo que muitas partes do código poderiam ser melhoradas e simplificadas, porem optei por manter assim!


# ------------------------ EXPORT ------------------------

@export var character_info: CharacterInfo = null

@export_group("Nodes")
@export var state_machine: StateMachine = null
@export var flip_container: Node2D = null

@export_group("Animation")
@export var paddle_animated_sprite: AnimatedSprite2D = null 
@export var body_animated_sprite: AnimatedSprite2D = null

@export_group("Sounds")
@export var footstep_player: AudioStreamPlayer = null
@export var attack_player: AudioStreamPlayer = null
@export var hit_player: AudioStreamPlayer = null

@export_group("Paddle")
@export var paddle_area: Area2D = null
@export_range(-360.0, 360.0, 1.0, "degrees") var min_rot_paddle: float = -80.0
@export_range(-360.0, 360.0, 1.0, "degrees") var max_rot_paddle: float = 80.0

# ------------------------ CONSTS ------------------------

const ATTACK_ROT_DURATION: float = 0.25

# ------------------------ VARS ------------------------

var is_dead: bool = false:
	set(value):
		is_dead = value
		var anim: String = "idle" if velocity == Vector2.ZERO else "walk"
		paddle_animated_sprite.stop()
		body_animated_sprite.stop()
		paddle_animated_sprite.play(anim + "_dead" if is_dead else "")
		body_animated_sprite.play(anim)

var flip_h: bool = false
var attack_tween: Tween = null
var in_attack: bool = false

var _area_body: Node2D = null
var _area_dir := Vector2.ZERO


# ======================== ATTACK ========================

func attack() -> void:
	if attack_tween and attack_tween.is_running():
		return
	if is_dead:
		return
	
	in_attack = true
	
	attack_player.play()
	attack_tween = create_tween()
	attack_tween.set_ease(Tween.EASE_IN_OUT)
	attack_tween.set_trans(Tween.TRANS_BACK)
	attack_tween.tween_property(paddle_animated_sprite, "rotation", deg_to_rad(min_rot_paddle), ATTACK_ROT_DURATION)
	attack_tween.tween_property(paddle_animated_sprite, "rotation", deg_to_rad(max_rot_paddle), ATTACK_ROT_DURATION)
	attack_tween.tween_property(paddle_animated_sprite, "rotation", 0.0, ATTACK_ROT_DURATION)
	
	await attack_tween.finished
	paddle_animated_sprite.rotation = 0.0
	
	_area_body = null
	_area_dir = Vector2.ZERO
	
	in_attack = false

func check_paddle_collision() -> void:
	for body: Node2D in paddle_area.get_overlapping_bodies():
		if not body.is_in_group("Ball"):
			continue
		if body != _area_body:
			_area_body = body
			_area_dir = global_position.direction_to(body.global_position).normalized()
		
		var ball_direction: Vector2 = _area_dir
		var sprite_dir: float = -1.0 if flip_h else 1.0
		ball_direction.x = abs(ball_direction.x) * sprite_dir
		ball_direction.normalized()
		body.update_direction(ball_direction)

# ======================== PUBLIC FUNCS ========================

func hit() -> void:
	hit_player.play()
	
	var shader: ShaderMaterial = material
	shader.set_shader_parameter("enable", true)
	await get_tree().create_timer(0.25).timeout
	shader.set_shader_parameter("enable", false)

func handle_movement(dir: Vector2, speed: float, sprite_scale: float) -> void:
	update_anim(true)
	update_sprites(sprite_scale, dir.x)
	footstep_player.pitch_scale = 1.25 * sprite_scale
	
	velocity.x = move_toward(velocity.x, dir.x * speed, speed)
	velocity.y = move_toward(velocity.y, dir.y * speed, speed)
	move_and_slide()

# ======================== UPDATE ========================

func update_sprites(speed_scale: float, value: float) -> void:
	body_animated_sprite.speed_scale = speed_scale
	paddle_animated_sprite.speed_scale = speed_scale
	
	if is_zero_approx(value): 
		return
	
	var diff_flip_h: bool = value < 0.0
	if flip_h == diff_flip_h:
		return
	
	flip_h = diff_flip_h
	flip_container.scale.x = -1.0 if flip_h else 1.0
	if attack_tween and attack_tween.is_running():
		attack_tween.finished.emit()
		attack_tween.kill()
		attack_player.stop()

func update_anim(walking: bool) -> void:
	var anim: String = "walk" if walking else "idle"
	body_animated_sprite.play(anim)
	paddle_animated_sprite.play(anim + "_dead" if is_dead else "")
