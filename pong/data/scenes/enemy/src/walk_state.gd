extends State


# ------------------------ VARS ------------------------

var predict_type: int = 0
var sprite_scale: float = 1.0
var target_pos := Vector2.ZERO
var target_offset := Vector2.ZERO
var target_offset_range: float = 60.0

# ======================== INIT ========================

func _ready() -> void:
	id = "walk"

# ======================== ENTER ========================

func enter() -> void:
	predict_type = [0, 1].pick_random()
	sprite_scale = 1.0
	target_offset = Vector2(
			randf_range(-target_offset_range, target_offset_range), 
			randf_range(-target_offset_range, target_offset_range)
	)
	target_pos = parent.get_random_pos()
	parent.footstep_player.play()

# ======================== PROCESS ========================

func handle_physics_process(delta: float) -> void:
	var step: int = 300 
	if parent.is_ball_after_middle(): 
		step = 60
		sprite_scale = parent.character_info.run_factor
	if parent.is_ball_after_middle() or parent.is_ball_coming():
		target_pos = parent.get_predict(delta, step, predict_type, target_offset)
	
	var dir: Vector2 = parent.global_position.direction_to(target_pos)
	var current_speed: float = parent.character_info.speed * sprite_scale
	
	if abs(dir.x) <= 0.1:
		dir.x = 0.0
	
	parent.handle_movement(dir, current_speed, sprite_scale)
	if parent.global_position.distance_to(target_pos) <= 30.0:
		machine.set_state("idle")
