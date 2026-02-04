extends Control


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/main_scene/main_scene.tscn")
