extends CanvasLayer


@export var player: Player = null
@export var init_container: Control = null
@export var credit_container: Control  = null
@export var init_button: BaseButton = null
@export var credit_button: BaseButton = null
@export var credit_back_button: BaseButton = null
@export_group("HUD")
@export var pause_button: BaseButton = null
@export_group("Menu")
@export var resume_button: BaseButton = null
@export var quit_button: BaseButton = null
@export_group("End")
@export var end_reset_button: BaseButton = null
@export var end_quit_button: BaseButton = null
@export_group("Containers")
@export var hud_container: Control = null
@export var menu_container: Control = null
@export var end_container: Control = null


# [NATIVEC] ----------------------------------------------------------------------------------------
func _ready() -> void:
	init_button.pressed.connect(_on_init_button_pressed)
	credit_button.pressed.connect(_on_credit_button_pressed)
	credit_back_button.pressed.connect(_on_credit_back_button_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)
	
	resume_button.pressed.connect(_on_resume_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	end_reset_button.pressed.connect(_on_reset_button_pressed)
	end_quit_button.pressed.connect(_on_quit_button_pressed)
	
	init_container.visible = true
	credit_container.visible = false
	hud_container.visible = false
	menu_container.visible = false
	end_container.visible = false
	
	player.dead.connect(_on_player_dead)
	
	Obstacles.speed = 500.0
	if MainCore.is_init:
		_init_game()

# [PRIVATE] ----------------------------------------------------------------------------------------
func _process_pause(value: bool) -> void:
	get_tree().paused = value
	hud_container.visible = not value
	menu_container.visible = value

# --------------------------------------------------------------------------------------------------
func _init_game() -> void:
	init_container.visible = false
	hud_container.visible = true
	player.init()

# [SIGNAL] -----------------------------------------------------------------------------------------
func _on_init_button_pressed() -> void:
	_init_game()
	MainCore.is_init = true

# --------------------------------------------------------------------------------------------------
func _on_credit_button_pressed() -> void:
	init_container.visible = false
	credit_container.visible = true

# --------------------------------------------------------------------------------------------------
func _on_credit_back_button_pressed() -> void:
	init_container.visible = true
	credit_container.visible = false

# --------------------------------------------------------------------------------------------------
func _on_pause_button_pressed() -> void:
	_process_pause(not get_tree().paused)

# --------------------------------------------------------------------------------------------------
func _on_resume_button_pressed() -> void:
	_process_pause(false)

# --------------------------------------------------------------------------------------------------
func _on_quit_button_pressed() -> void:
	MainCore.quit()

# --------------------------------------------------------------------------------------------------
func _on_reset_button_pressed() -> void:
	MainCore.reload_current_scene()

# --------------------------------------------------------------------------------------------------
func _on_player_dead() -> void:
	hud_container.visible = false
	Obstacles.speed = 0.0
	await get_tree().create_timer(1.25).timeout
	menu_container.visible = false
	end_container.visible = true
