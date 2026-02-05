extends CharacterBody2D

@export var speed: float = 300.0

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward","move_backward")
	velocity.x = move_toward(velocity.x,  dir.x * speed, speed)
	velocity.y = move_toward(velocity.y,  dir.y * speed, speed)
	
	move_and_slide()
