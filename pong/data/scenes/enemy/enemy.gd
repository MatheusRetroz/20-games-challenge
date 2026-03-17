extends Character


# ------------------------ EXPORT ------------------------

@export var ball: CharacterBody2D = null
@export var init_position := Vector2.ZERO

# ------------------------ VARS ------------------------

var front: int = -1
var margin := Vector2(35.0, 72.5)


# ======================== PROCESS ========================

func _process(delta: float) -> void:
	state_machine.handle_process(delta)

func _physics_process(delta: float) -> void:
	
	state_machine.handle_physics_process(delta)
	if paddle_area.has_overlapping_bodies():
		if flip_h:
			attack()
			check_paddle_collision()

# ======================== GET ========================

func get_random_pos() -> Vector2:
	var min_pos := Vector2(ScreenManager.SCREEN_SIZE.x - character_info.court_size, 0.0) + margin
	var max_pos: Vector2 = ScreenManager.SCREEN_SIZE - margin
	var mid_pos: Vector2 = (max_pos - min_pos) / 2.0
	
	var offset := Vector2(
		randf_range(-mid_pos.x, mid_pos.x),
		randf_range(-mid_pos.y, mid_pos.y)
	)
	return min_pos + mid_pos + offset

func get_predict(delta: float, step: int, predict_type: int, offset := Vector2.ZERO) -> Vector2:
	var current_vel := Vector2(abs(ball.velocity.x), ball.velocity.y) 
	var current_pos: Vector2 = ball.global_position
	
	if is_zero_approx(current_vel.x):
		if is_ball_after_middle():
			return _clamp_position(current_pos)
		return global_position
	
	for i: int in range(step):
		current_pos += current_vel * delta
		if current_pos.y <= 0.0 or current_pos.y >= ScreenManager.SCREEN_SIZE.y:
			current_vel.y *= -1.0
		
		match predict_type:
			0:
				if abs((global_position.x + offset.x)  - current_pos.x) < 10.0:
					break
			1:
				if current_pos.x >= (ScreenManager.SCREEN_SIZE.x - margin.x):
					break
	return _clamp_position(current_pos)

# ======================== PUBLIC HELPERS ========================

func is_ball_coming() -> bool:
	return ball.velocity.x > 0.0

func is_ball_after_middle() -> bool:
	return ball.global_position.x >= (ScreenManager.SCREEN_SIZE.x / 2.0) + 32.0

func _clamp_position(pos: Vector2) -> Vector2:
	var min_pos := Vector2(ScreenManager.SCREEN_SIZE.x - character_info.court_size, 0.0) + margin
	var max_pos: Vector2 = ScreenManager.SCREEN_SIZE - margin
	return pos.clamp(min_pos, max_pos)
