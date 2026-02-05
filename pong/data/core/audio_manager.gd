extends Node

# --- Consts ---
const BUTTON_HOVER_STREAM: AudioStream = preload("res://common/audios/ui/kenney_sounds/click_003.ogg")
const BUTTON_PRESSED_STREAM: AudioStream = preload("res://common/audios/ui/kenney_sounds/click_002.ogg")

# --- Volume db ---
var ui_db: float = linear_to_db(0.01)
var game_db: float = 0.0

# --- Sound State (on/off) ---
var button_sound_enabled: bool = true

# --- Playback ---
var ui_playback: AudioStreamPlaybackPolyphonic = null
var game_playback: AudioStreamPlaybackPolyphonic = null

# ------ Init ------

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _ready() -> void:
	ui_playback = _get_playback("UIAudioStreamPlayer", &"UI")
	game_playback = _get_playback("GameAudioStreamPlayer")

# ------ Funcs ------

func _get_playback(title: String, bus: String = &"Master", polyphony: int = 32) -> AudioStreamPlaybackPolyphonic:
	var player := AudioStreamPlayer.new()
	player.name = title
	player.bus = bus
	add_child(player, true)
	
	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = polyphony
	player.stream = stream
	player.play()
	
	return player.get_stream_playback()

# ------ Signals ------

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.mouse_entered.connect(_on_button_mouse_entered.bind(node))
		node.focus_entered.connect(_on_button_focus_entered)
		node.pressed.connect(_on_button_pressed)

func _on_button_mouse_entered(button: BaseButton) -> void:
	button.grab_focus()

func _on_button_focus_entered() -> void:
	if button_sound_enabled:
		ui_playback.play_stream(BUTTON_HOVER_STREAM, 0.0, ui_db)

func _on_button_pressed() -> void:
	if button_sound_enabled:
		ui_playback.play_stream(BUTTON_PRESSED_STREAM, 0.0, ui_db)
