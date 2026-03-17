extends State


# ------------------------ VARS ------------------------

var sprite_scale: float = 1.0


# ======================== INIT ========================

func _ready() -> void:
	id = "walk"

# ======================== ENTER ========================

func enter() -> void:
	sprite_scale = 1.0
	parent.footstep_player.play()

# ======================== PROCESS ========================

func handle_physics_process(_delta: float) -> void:
	if Input.is_action_pressed("action_run"):
		sprite_scale = parent.character_info.run_factor
	else:
		sprite_scale = 1.0
	
	var dir: Vector2 = parent.get_dir()
	var current_speed: float = parent.character_info.speed * sprite_scale
	
	parent.handle_movement(dir, current_speed, sprite_scale)
	
	if dir == Vector2.ZERO:
		machine.set_state("idle")
