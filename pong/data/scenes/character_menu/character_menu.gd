extends Control

# --- Export ---
@export var init_button: BaseButton = null
@export var back_button: BaseButton = null
@export_group("Group")
@export var character_button_group: ButtonGroup = null

var _current_character: CharacterInfo = null

# ------ Init ------

func _ready() -> void:
	MainCore.set_menu(&"character", self)
	
	init_button.visible = false
	
	character_button_group.pressed.connect(_on_character_group_pressed)
	init_button.pressed.connect(_on_init_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

# ------ Signals ------

func _on_character_group_pressed(button: BaseButton) -> void:
	if button is CharacterButton:
		_current_character = button.character_info if button.button_pressed else null
	
	init_button.visible = button.button_pressed

func _on_init_button_pressed() -> void:
	if _current_character:
		get_tree().change_scene_to_file("res://scenes/main_scene/main_scene.tscn")

func _on_back_button_pressed() -> void:
	var button: BaseButton = character_button_group.get_pressed_button()
	if button:
		init_button.visible = false
		_current_character = null
		button.button_pressed = false
	MainCore.go_to_menu(&"main")
