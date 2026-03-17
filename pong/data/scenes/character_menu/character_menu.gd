extends Control


# ------------------------ EXPORT ------------------------

@export var play_button: BaseButton = null
@export var back_button: BaseButton = null
@export var character_button_group: ButtonGroup = null


# ======================== INIT ========================

func _ready() -> void:
	MainCore.set_menu(&"character", self)
	
	play_button.visible = false
	
	character_button_group.pressed.connect(_on_character_group_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

# ======================== SIGNALS ========================

func _on_character_group_pressed(button: BaseButton) -> void:
	play_button.visible = button.button_pressed
	CharacterInfo.current_resource = button.get("character_info")

func _on_play_button_pressed() -> void:
	await ScreenManager.set_transition(true)
	await get_tree().create_timer(0.5).timeout
	MainCore.go_to_scene("res://scenes/main_scene/main_scene.tscn")

func _on_back_button_pressed() -> void:
	if ScreenManager.in_transition(): return
	
	var button: BaseButton = character_button_group.get_pressed_button()
	if button:
		play_button.visible = false
		button.button_pressed = false
		CharacterInfo.current_resource = null
	MainCore.go_to_menu(&"main")
