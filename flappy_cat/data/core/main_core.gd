extends Node


const VERSION: String = "0.1v"

var high_score: int = 0
var score: int = 0


# --------------------------------------------------------------------------------------------------
func add_score() -> void:
	score += 1


# --------------------------------------------------------------------------------------------------
func reload_current_scene() -> void:
	get_tree().reload_current_scene()
	if score > high_score: high_score = score
	score = 0
	Obstacles.speed = 300.0
