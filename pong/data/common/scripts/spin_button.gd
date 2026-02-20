extends HBoxContainer
class_name SpinButton

# --- Signals ---
signal index_changed(index: int)

# --- Export ---
@export var left_button: BaseButton = null
@export var right_button: BaseButton = null
@export var label: Label = null
@export var values: Array[String] = []

var current_index: int = 0: 
	set(value):
		current_index = value
		label.text = values[current_index]
		
		var min_value: int = 0
		var max_value: int = values.size() -1
		left_button.disabled = current_index == min_value
		right_button.disabled = current_index == max_value
		
		index_changed.emit(current_index)

# ------ Init ------

func _ready() -> void:
	current_index = current_index
	
	left_button.pressed.connect(_on_left_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)

func _change_index(value: int) -> void:
	var min_value: int = 0
	var max_value: int = values.size() -1
	current_index = clamp(current_index + value, min_value, max_value)

# ------ Signals ------

func _on_left_button_pressed() -> void:
	_change_index(-1)

func _on_right_button_pressed() -> void:
	_change_index(1)
