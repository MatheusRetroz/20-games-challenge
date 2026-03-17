extends Character


# ======================== INIT ========================

func _ready() -> void:
	character_info = CharacterInfo.current_resource
	if not character_info:
		character_info = CharacterInfo.cat_resource
	body_animated_sprite.sprite_frames = character_info.body_sprite_frames
	paddle_animated_sprite.sprite_frames = character_info.paddle_sprite_frames

# ======================== INPUT ========================

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			attack()

# ======================== PROCESS ========================

func _process(delta: float) -> void:
	state_machine.handle_process(delta)

func _physics_process(delta: float) -> void:
	state_machine.handle_physics_process(delta)
	if in_attack:
		check_paddle_collision()

# ======================== GET ========================

func get_dir() -> Vector2:
	var dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward","move_backward")
	return dir.normalized()
