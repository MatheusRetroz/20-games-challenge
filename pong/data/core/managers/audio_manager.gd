extends Node

## Singleton de gerenciamento de áudio
## Foi simplificado, resumindo sua função apenas para o controle do som da UI, como botões e sliders
## A Ideia era elaborar mais, adicionando o controle de efeitos, porem simplifiquei para manter o controle do áudio centralizado a cena.


# ------------------------ CONSTS ------------------------

const HOVER_STREAM: AudioStream = preload("res://common/audios/ui/hover.mp3")
const PRESSED_STREAM: AudioStream = preload("res://common/audios/ui/pressed.mp3")

# ------------------------ VARS ------------------------

# Volume db
var ui_db: float = linear_to_db(0.1)
# Playback
var ui_playback: AudioStreamPlaybackPolyphonic = null


# ======================== INIT ========================

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	ui_playback = _create_playback("UIAudioStreamPlayer", &"UI")

# ======================== PUBLIC FUNCS ========================

func play_sound(key: String, stream: AudioStream, db: float = 0.0, pitch_scale: float = 1.0) -> int:
	match key:
		&"ui":
			return ui_playback.play_stream(stream, 0.0, ui_db - db, pitch_scale)
	return -1

# ======================== PRIVATE FUNCS ========================

func _create_playback(title: String, bus: String = &"Master", polyphony: int = 32) -> AudioStreamPlaybackPolyphonic:
	var player := AudioStreamPlayer.new()
	player.name = title
	player.bus = bus
	add_child(player, true)
	
	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = polyphony
	player.stream = stream
	player.play()
	
	return player.get_stream_playback()

# ======================== SIGNALS ========================

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
	play_sound(&"ui", HOVER_STREAM)

func _on_node_pressed() -> void:
	play_sound(&"ui", PRESSED_STREAM)
