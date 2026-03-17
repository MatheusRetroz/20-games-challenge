extends Node2D


# ------------------------ EXPORT ------------------------

@export_group("Game")
@export var ball: CharacterBody2D = null
@export var player: Character = null
@export var enemy: Character = null
@export var player_spawn: Node2D = null
@export var enemy_spawn: Node2D = null
@export var center_spawn: Node2D = null

@export var player_map_limit: Sprite2D = null
@export var enemy_map_limit: Sprite2D = null

@export_group("Point")
@export var point_area: Area2D = null
@export var player_point_label: Label = null
@export var player_set_label: Label = null
@export var enemy_point_label: Label = null
@export var enemy_set_label: Label = null
@export var small_whistle_player: AudioStreamPlayer = null
@export var long_whistle_player: AudioStreamPlayer = null

@export_subgroup("UI")
@export var game_label: Label = null
@export var unlocked_label: Label = null
@export var unlocked_player: AudioStreamPlayer = null
@export var init_container: Control = null
@export var point_container: Control = null
@export var play_again_button: BaseButton = null

@export_group("Menu")
@export var main_container: Control = null
@export var resume_button: BaseButton = null
@export var options_button: BaseButton = null
@export var reset_button: BaseButton = null
@export var quit_to_menu_button: BaseButton = null

# ------------------------ CONSTS ------------------------

const POINTS_TO_WIN_SET: int = 3
const SETS_TO_WIN_GAME: int = 3

# ------------------------ VARS ------------------------

var player_point: int = 0:
	set(value):
		player_point = value
		_update_label(player_point_label, "%02d" % player_point)
var enemy_point: int = 0:
	set(value):
		enemy_point = value
		_update_label(enemy_point_label, "%02d" % enemy_point)
var player_sets: int = 0:
	set(value):
		player_sets = value
		_update_label(player_set_label, str(player_sets))
var enemy_sets: int = 0:
	set(value):
		enemy_sets = value
		_update_label(enemy_set_label, str(enemy_sets))

# ------------------------ INIT HELPER ------------------------

func _update_label(node: Label, value: String) -> void:
	if node: node.text = value


# ======================== INIT ========================

func _ready() -> void:
	ball.reset(center_spawn.global_position)
	
	player.global_position = player_spawn.global_position
	enemy.init_position = enemy_spawn.global_position
	
	# Signals
	point_area.body_entered.connect(_on_area_body_entered)
	
	resume_button.pressed.connect(_on_resume_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	quit_to_menu_button.pressed.connect(_on_quit_to_menu_button_pressed)
	
	play_again_button.pressed.connect(_on_play_again_button_pressed)
	
	MainCore.set_menu(&"main", main_container)
	MainCore.go_to_menu(&"main")
	MainCore.go_to_menu("")
	ScreenManager.set_transition(false)
	
	# Init
	play_again_button.visible = false
	
	game_label.visible = false
	game_label.modulate.a = 0.0
	
	ball.visible = true
	ball.modulate.a = 0.0
	
	init_container.visible = true
	init_container.modulate.a = 1.0
	
	point_container.visible = true
	point_container.modulate.a = 0.0
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	tween.tween_property(init_container, "modulate:a", 0.0, 4.0)
	tween.tween_property(point_container, "modulate:a", 1.0, 2.0)
	tween.parallel().tween_property(ball, "modulate:a", 1.0, 2.0)
	
	await tween.finished
	
	init_container.visible = false
	
	enemy.state_machine.set_state("init")
	await get_tree().create_timer(2.0).timeout
	long_whistle_player.play()
	_init_ball()

# ======================== INPUT ========================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		MainCore.go_to_menu(&"main")
		get_tree().paused = MainCore.current_menu == &"main"

# ======================== PROCESS ========================

func _process(_delta: float) -> void:
	_update_map_limit(player, player_map_limit, 1.0)
	_update_map_limit(enemy, enemy_map_limit, -1.0)

# ======================== PRIVATE FUNCS ========================

func _init_ball() -> void:
	var value: Vector2 = [Vector2.RIGHT, Vector2.LEFT].pick_random()
	var angle: float = PI / 4.0
	var dir: Vector2 = value.rotated([angle, -angle, 0.0].pick_random())
	ball.current_direction = dir.normalized()

func _reset_ball(is_player_side: bool) -> void:
	var spawn_pos: Vector2 = player_spawn.global_position
	var spawn_size: float = player.character_info.court_size if is_player_side else enemy.character_info.court_size
	var direction: int = -1 if is_player_side else 1
	
	if is_player_side:
		spawn_pos = enemy_spawn.global_position
	
	spawn_pos.x += (spawn_size / 2.0) * direction
	ball.reset(spawn_pos)

func _update_map_limit(node: Character, map: Sprite2D, dir: float) -> void:
	var distance: float = (map.global_position.x - node.global_position.x)
	distance = (distance / node.character_info.court_size) * 2.0 * dir
	distance = clamp(1.0 - distance, 0.0, 1.0)
	map.modulate.a = distance

func _update_game_label(text: String) -> void:
	game_label.text = text
	game_label.visible = true
	game_label.modulate.a = 0.0
	
	var tween: Tween = create_tween()
	tween.tween_property(game_label, "modulate:a", 1.0, 2.0)
	tween.tween_property(game_label, "modulate:a", 0.0, 2.0)
	
	await tween.finished
	game_label.visible = false

func _unlocked_character() -> void:
	if CharacterInfo.cucumber_resource.locked:
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.tween_property(unlocked_label, "position:x", 48.0, 1.0)
		CharacterInfo.cucumber_resource.locked = false
		
		await get_tree().create_timer(0.5).timeout
		unlocked_player.play()

# ======================== POINT/SET ========================

func _check_set_point() -> void:
	if player_point >= POINTS_TO_WIN_SET:
		_update_set("player")
	if enemy_point >= POINTS_TO_WIN_SET:
		_update_set("enemy")

func _update_set(winner: String) -> void:
	var update_set: bool = false
	
	match winner:
		"player":
			player_point = 0
			player_sets += 1
			if player_sets >= SETS_TO_WIN_GAME:
				_end_game("player")
			else:
				update_set = true
		"enemy":
			enemy_point = 0
			enemy_sets += 1
			if enemy_sets >= SETS_TO_WIN_GAME:
				_end_game("enemy")
			else:
				update_set = true
	
	if update_set:
		small_whistle_player.play()
		ball.reset(center_spawn.global_position)
		await _update_game_label("game.label.set_finished")
		await get_tree().create_timer(1.0).timeout
		long_whistle_player.play()
		_init_ball()

func _end_game(winner: String) -> void:
	ball.current_direction = Vector2.ZERO
	ball.reset(center_spawn.global_position)
	ball.visible = false
	
	long_whistle_player.play()
	play_again_button.visible = true
	
	var text: String = ""
	match winner:
		"player":
			_unlocked_character()
			enemy.is_dead = true
			text = "game.label.player_win"
		"enemy":
			player.is_dead = true
			text = "game.label.enemy_win"
	_update_game_label(text)

func _reset_game() -> void:
	get_tree().paused = false
	await ScreenManager.set_transition(true)
	get_tree().reload_current_scene()

# ======================== SIGNALS ========================

func _on_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Ball"): return
	
	var is_player_side: bool = body.global_position.x < 640.0
	_reset_ball(is_player_side)
	
	if is_player_side:
		player.hit()
		enemy_point += 1
	else:
		enemy.hit()
		player_point += 1
	_check_set_point()

func _on_resume_button_pressed() -> void:
	if ScreenManager.in_transition(): return
	
	get_tree().paused = false
	MainCore.go_to_menu("")

func _on_options_button_pressed() -> void:
	MainCore.go_to_menu(&"options")

func _on_reset_button_pressed() -> void:
	_reset_game()

func _on_play_again_button_pressed() -> void:
	_reset_game()

func _on_quit_to_menu_button_pressed() -> void:
	await ScreenManager.set_transition(true)
	await get_tree().create_timer(0.5).timeout
	MainCore.go_to_scene("res://scenes/main_menu/main_menu.tscn")
