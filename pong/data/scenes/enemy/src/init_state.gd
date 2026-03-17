extends State


# ======================== INIT ========================

func _ready() -> void:
	id = "init"

# ======================== ENTER ========================

func enter() -> void:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	parent.update_anim(false)
	parent.update_sprites(1.0, parent.front)
	parent.footstep_player.stop()

# ======================== PROCESS ========================

func handle_physics_process(_delta: float) -> void:
	var dir: Vector2 = parent.global_position.direction_to(parent.init_position).normalized()
	parent.handle_movement(dir, parent.character_info.speed, 1.0)
	
	if parent.global_position.distance_to(parent.init_position) <= 10.0:
		machine.set_state("idle")
