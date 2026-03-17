extends Node
class_name State
@warning_ignore_start("unused_parameter")


# ------------------------ VARS ------------------------

var id: String = ""
var machine: StateMachine = null
var parent: Character = null


# ======================== ENTER ========================

func enter() -> void:
	pass

func exit() -> void:
	pass

# ======================== PROCESS ========================
 
func handle_process(delta: float) -> void:
	pass

func handle_physics_process(delta: float) -> void:
	pass
