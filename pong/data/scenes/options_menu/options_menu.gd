extends Control


# ------------------------ EXPORT ------------------------

@export_group("Buttons")
@export var language_button: SpinButton = null
@export var window_mode_spin: SpinButton = null
@export var back_button: BaseButton = null

@export_group("Sounds")
@export var sound_main_slider: HSlider = null
@export var sound_music_slider: HSlider = null
@export var sound_sfx_slider: HSlider = null


# ======================== INIT ========================

func _enter_tree() -> void:
	match OS.get_name():
		"Web", "Android":
			%ScreenLabel.visible = false
			%WindowModeContainer.visible = false

func _ready() -> void:
	MainCore.set_menu(&"options", self)
	
	language_button.current_index = 0 if TranslationServer.get_locale() == "en_US" else 1
	
	var window_mode: int = 0
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_mode = 1
	window_mode_spin.current_index = window_mode
	
	var main_volume: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master"))
	sound_main_slider.value = db_to_linear(main_volume)
	var music_volume: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Music"))
	sound_music_slider.value = db_to_linear(music_volume)
	var sfx_volume: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Sfx"))
	sound_sfx_slider.value = db_to_linear(sfx_volume)
	
	language_button.index_changed.connect(_on_language_index_changed)
	window_mode_spin.index_changed.connect(_on_fullscreen_index_changed)
	
	sound_main_slider.value_changed.connect(_on_sound_main_value_changed)
	sound_music_slider.value_changed.connect(_on_sound_music_value_changed)
	sound_sfx_slider.value_changed.connect(_on_sound_sfx_value_changed)
	
	back_button.pressed.connect(_on_back_button_pressed)

# ======================== SIGNALS ========================

func _on_language_index_changed(index: int) -> void:
	var locale: String = ""
	match index:
		0:
			locale = "en_US"
		1:
			locale = "pt_BR"
	TranslationServer.set_locale(locale)

func _on_fullscreen_index_changed(index: int) -> void:
	var mode := DisplayServer.WINDOW_MODE_WINDOWED if index == 0 else DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(mode)

func _on_sound_main_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Master"), linear_to_db(value))

func _on_sound_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), linear_to_db(value))

func _on_sound_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Sfx"), linear_to_db(value))

func _on_back_button_pressed() -> void:
	if visible: MainCore.go_to_menu(&"main")
