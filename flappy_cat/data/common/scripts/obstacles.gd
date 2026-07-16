extends Node2D
class_name Obstacles


signal point_collected()
const SPACE: float = 400.0
const SIZE: float = 150.0
const MARGIN: float = 25.0

static var texture: Texture2D = preload("res://common/textures/obstacle.png")
static var speed: float = 500.0
var offset: float = 0.0


# [NATIVE] -----------------------------------------------------------------------------------------
func _ready() -> void:
	_generate_offset()
	_create_point_area()
	_create_top_obstacle()
	_create_bottom_obstacle()

# --------------------------------------------------------------------------------------------------
func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x <= -SIZE:
		queue_free()

# [PRIVATE] ----------------------------------------------------------------------------------------
func _generate_offset() -> void:
	randomize()
	var min_value: float = 200 + SPACE
	var max_value: float = get_viewport_rect().size.y - SPACE
	var steps: float = 10.0
	var max_steps: int = int((max_value - min_value) / steps)
	offset = min_value + (randi_range(0, max_steps) * steps)

# --------------------------------------------------------------------------------------------------
func _create_area(collision_size: float, collision_pos: float, pos: float) -> Area2D:
	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size.x = SIZE
	collision.shape.size.y = max(0.0, collision_size)
	collision.position.y = collision_pos
	var area := Area2D.new()
	area.name = "Obstacle_00"
	area.position.y = pos
	area.add_child(collision, true)
	return area

# --------------------------------------------------------------------------------------------------
func _create_sprite(texture_offset: float, flip_v: bool) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.centered = false
	sprite.flip_v = true
	sprite.texture = texture
	sprite.offset.y  = texture_offset
	sprite.position.x = -(texture.get_size().x / 2.0)
	return sprite

# --------------------------------------------------------------------------------------------------
func _create_top_obstacle() -> void:
	var vertical_size: float = get_viewport_rect().size.y
	var shape_size: float = vertical_size - (offset + SPACE)
	var obstacle: Area2D = _create_area(shape_size - MARGIN, shape_size / 2.0, 0.0)
	var sprite: Sprite2D = _create_sprite(-(offset + SPACE - (1920.0 - texture.get_size().y)), true)

	obstacle.add_child(sprite, true)	
	obstacle.name = "TopObstacle"
	obstacle.body_entered.connect(_on_area_body_entered)
	add_child(obstacle, true)

# --------------------------------------------------------------------------------------------------
func _create_bottom_obstacle() -> void:
	var vertical_size: float = get_viewport_rect().size.y
	var shape_size: float = offset - SPACE
	var obstacle: Area2D = _create_area(shape_size - MARGIN, -shape_size / 2.0, vertical_size)
	var sprite: Sprite2D = _create_sprite(-(offset - SPACE), false)
	
	obstacle.add_child(sprite, true)
	obstacle.name = "BottomObstacle"
	obstacle.body_entered.connect(_on_area_body_entered)
	add_child(obstacle, true)

# --------------------------------------------------------------------------------------------------
func _create_point_area() -> void:
	var vertical_size: float = get_viewport_rect().size.y
	var area_pos: float = vertical_size - offset - SPACE
	var area: Area2D = _create_area(SPACE * 2.0 + MARGIN, SPACE, area_pos)
	var collision: CollisionShape2D = area.get_node("CollisionShape2D")
	collision.shape.size.x = 20
	area.name = "PointArea"
	area.body_entered.connect(_on_point_area_body_entered.bind(area))
	add_child(area, true)

# [SIGNAL] -----------------------------------------------------------------------------------------
func _on_area_body_entered(body: Node2D) -> void:
	if body is Player and not body.is_dead:
		body.hit()

# --------------------------------------------------------------------------------------------------
func _on_point_area_body_entered(body: Node2D, area: Area2D) -> void:
	if body is Player and not body.is_dead:
		area.set_deferred("monitorable", false)
		area.set_deferred("monitoring", false)
		point_collected.emit()
