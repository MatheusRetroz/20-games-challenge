extends Node
class_name StateMachine


# ------------------------ EXPORT ------------------------

@export var parent: Character = null
@export var states: Array[State] = []

# ------------------------ VARS ------------------------

var current_state: State = null


# ======================== INIT ========================

func _ready() -> void:
	for state: State in states:
		state.machine = self
		state.parent = parent
	current_state = states[0]
	current_state.enter()

# ======================== PROCESS ========================

func handle_process(delta: float) -> void:
	current_state.handle_process(delta)

func handle_physics_process(delta: float) -> void:
	current_state.handle_physics_process(delta)

# ======================== SET ========================

func set_state(id: String) -> void:
	if id == current_state.id: return
	
	var new_state: State = null
	for state: State in states:
		if state.id == id:
			new_state = state
			break
	
	if new_state:
		current_state.exit()
		current_state = new_state
		current_state.enter()
