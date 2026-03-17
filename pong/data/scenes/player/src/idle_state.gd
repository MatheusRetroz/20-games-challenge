extends State


# ======================== INIT ========================

func _ready() -> void:
	id = "idle"

# ======================== ENTER ========================

func enter() -> void:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	parent.update_anim(false)
	parent.update_sprites(1.0, 0.0)
	parent.footstep_player.stop()

# ======================== PROCESS ========================

func handle_physics_process(_delta: float) -> void:
	if parent.get_dir() != Vector2.ZERO:
		machine.set_state("walk")
