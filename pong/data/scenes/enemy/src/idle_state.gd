extends State


# ------------------------ VARS ------------------------

var random_time: float = 2.0


# ======================== INIT ========================

func _ready() -> void:
	id = "idle"

# ======================== ENTER ========================

func enter() -> void:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	parent.update_anim(false)
	parent.update_sprites(1.0, parent.front)
	parent.footstep_player.stop()
	
	random_time = 2.0

# ======================== PROCESS ========================

func handle_physics_process(delta: float) -> void:
	if parent.is_ball_coming():
		var target_pos: Vector2 = parent.get_predict(delta, 300, 0)
		var distance: float = parent.global_position.distance_to(target_pos)
		if distance > 60.0:
			machine.set_state("walk")
	elif random_time <= 0.0:
		machine.set_state("walk")
	random_time -= delta
