extends Control

@export var main_container: Control = null
@export_group("Buttons")
@export var start_button: BaseButton = null
@export var options_button: BaseButton = null
@export var quit_button: BaseButton = null

var _fade_in_resource: TweenResource = null
var _fade_out_resource: TweenResource = null


func _enter_tree() -> void:
	main_container.modulate.a = 0.0
	
	if OS.get_name() == "Web":
		quit_button.disabled = true
		quit_button.visible = false

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	_fade_in_resource = TweenResource.new()
	_fade_in_resource.ease_type = Tween.EASE_IN_OUT
	_fade_in_resource.trans_type = Tween.TRANS_QUAD
	_fade_in_resource.property = "modulate:a"
	_fade_in_resource.value = 1.0
	
	_fade_out_resource = TweenResource.new()
	_fade_out_resource.ease_type = Tween.EASE_IN
	_fade_out_resource.trans_type = Tween.TRANS_SINE
	_fade_out_resource.property = "modulate:a"
	_fade_out_resource.value = 0.0
	
	_fade_in_resource.run_tween(main_container)

# Signals
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene/main_scene.tscn")

func _on_options_button_pressed() -> void:
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
