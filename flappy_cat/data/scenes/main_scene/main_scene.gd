extends Node2D


const DISTANCE: float = 800.0

@export var player: Player = null
@export var obstacles_container: Node2D = null

var _current_obstacle: Obstacles = null


# [NATIVE] -----------------------------------------------------------------------------------------
func _ready() -> void:
	player.dead.connect(_on_player_dead)

# --------------------------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	if _current_obstacle:
		var distance: float = DISTANCE - Obstacles.SIZE
		if _current_obstacle.position.x <= get_viewport_rect().size.x - distance:
			var pos: float = _current_obstacle.position.x + DISTANCE
			_current_obstacle = _spawn_obstacle(pos)
	else:
		_current_obstacle = _spawn_obstacle(get_viewport_rect().size.x + Obstacles.SIZE)

# [PRIVATE] ----------------------------------------------------------------------------------------
func _spawn_obstacle(pos: float) -> Node2D:
	var obstacle := Obstacles.new()
	obstacle.name = "Obstacle_00"
	obstacle.position.x = pos
	obstacle.point_collected.connect(_on_obstacle_point_collected)
	obstacles_container.add_child(obstacle, true)
	return obstacle

# [SIGNAL] -----------------------------------------------------------------------------------------
func _on_player_dead() -> void:
	Obstacles.speed = 0.0
	await get_tree().create_timer(2.0).timeout
	MainCore.reload_current_scene()

# --------------------------------------------------------------------------------------------------
func _on_obstacle_point_collected() -> void:
	MainCore.add_score()
