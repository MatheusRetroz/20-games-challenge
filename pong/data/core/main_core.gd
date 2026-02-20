extends Node

# --- Consts ---
const VERSION: String = "0.0.4"

# --- Vars --
var menus: Dictionary[String, Control] = {}
var current_menu: String = ""


# ------ Menus ------

func set_menu(key: String, node: Control) -> void:
	if menus.has(key): return
	menus[key] = node

func go_to_menu(key: String) -> void:
	if current_menu == key: 
		return
	for menu_name: String in menus:
		menus[menu_name].visible = menu_name == key
	current_menu = key
