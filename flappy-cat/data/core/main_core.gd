extends Node


signal score_changed(value: int)
signal high_score_changed(value: int)
const VERSION: String = "1.0.0"

var is_init: bool = false
var score: int = 0: set = set_score
var high_score: int = 0: set = set_high_score

var _ambient_player: AudioStreamPlayer = null


# [READY]-------------------------------------------------------------------------------------------
func _ready() -> void:
	_ambient_player = AudioStreamPlayer.new()
	_ambient_player.stream = load("res://common/audios/forest_ambience.mp3")
	_ambient_player.autoplay = true
	_ambient_player.bus = &"Ambient"
	add_child(_ambient_player, true)

# [SET] --------------------------------------------------------------------------------------------
func set_score(value: int) -> void:
	score = value
	if score > high_score:
		high_score = score
	score_changed.emit(score)

# --------------------------------------------------------------------------------------------------
func set_high_score(value: int) -> void:
	high_score = value
	high_score_changed.emit(high_score)

# [PUBLIC] -----------------------------------------------------------------------------------------
func add_score() -> void:
	score += 1

# --------------------------------------------------------------------------------------------------
func reload_current_scene() -> void:
	get_tree().reload_current_scene()
	score = score
	score = 0

# --------------------------------------------------------------------------------------------------
func quit() -> void:
	is_init = false
	get_tree().paused = false
	reload_current_scene()
