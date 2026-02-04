extends Camera2D


func _ready() -> void:
	position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2.0
	position.y = ProjectSettings.get_setting("display/window/size/viewport_height") / 2.0
