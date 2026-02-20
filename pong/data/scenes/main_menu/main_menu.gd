extends Control

# --- Export ---
@export var main_container: Control = null
@export_group("Buttons")
@export var start_button: BaseButton = null
@export var options_button: BaseButton = null
@export var credits_button: BaseButton = null
@export var quit_button: BaseButton = null


# ------ Init ------

func _enter_tree() -> void:
	match OS.get_name():
		"Web", "Android":
			quit_button.disabled = true
			quit_button.visible = false

func _ready() -> void:
	$MainContainer/RightContainer/VersionLabel.text = "V" + MainCore.VERSION
	
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	MainCore.set_menu(&"main", main_container)
	MainCore.go_to_menu(&"main")

# ------ Signals ------

func _on_start_button_pressed() -> void:
	MainCore.go_to_menu(&"character")

func _on_options_button_pressed() -> void:
	MainCore.go_to_menu(&"options")
	
func _on_credits_button_pressed() -> void:
	MainCore.go_to_menu(&"credits")
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
