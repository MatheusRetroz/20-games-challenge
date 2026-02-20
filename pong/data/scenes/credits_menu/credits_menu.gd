extends Control

@export var back_button: BaseButton = null


func _ready() -> void:
	MainCore.set_menu(&"credits", self)
	
	back_button.pressed.connect(_on_back_button)

func _on_back_button() -> void:
	MainCore.go_to_menu(&"main")
