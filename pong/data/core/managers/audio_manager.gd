extends Node

# --- Consts ---
const HOVER_STREAM: AudioStream = preload("res://common/audios/ui/kenney_sounds/click_003.ogg")
const PRESSED_STREAM: AudioStream = preload("res://common/audios/ui/kenney_sounds/click_002.ogg")

# --- Volume db ---
var ui_db: float = linear_to_db(0.01)
var game_db: float = 0.0

# --- Sound State (on/off) ---
var ui_sound_enabled: bool = true

# --- Playback ---
var ui_playback: AudioStreamPlaybackPolyphonic = null
var game_playback: AudioStreamPlaybackPolyphonic = null

# ------ Init ------

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _ready() -> void:
	ui_playback = _get_playback("UIAudioStreamPlayer", &"Sfx")
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

func _play_sound(stream: AudioStream) -> void:
	if ui_sound_enabled:
		ui_playback.play_stream(stream, 0.0, ui_db)

# ------ Signals ------

func _on_node_added(node: Node) -> void:
	if not (node is BaseButton or node is Slider):
		return
	
	node.mouse_entered.connect(_on_node_mouse_entered.bind(node))
	node.focus_mode = Control.FOCUS_NONE
	if node is BaseButton:
		node.pressed.connect(_on_node_pressed)
	elif node is Slider:
		node.drag_started.connect(_on_node_pressed)

func _on_node_mouse_entered(node: Control) -> void:
	if node is BaseButton:
		if node.disabled: return
	elif node is Slider:
		if not node.editable: return
	_play_sound(HOVER_STREAM)

func _on_node_pressed() -> void:
	_play_sound(PRESSED_STREAM)
