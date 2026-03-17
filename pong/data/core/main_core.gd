extends Node

## O "principal" singleton.
## Controle de menus e de troca de cena;
## Simplificado para não elaborar demais o projeto 


# ------------------------ CONSTS ------------------------

const VERSION: String = "1.0.0"

# ------------------------ VARS ------------------------

# Menu
var menus: Dictionary[String, Array] = {}
var current_menu: String = ""

# ======================== INIT ========================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# ======================== SET ========================

func set_menu(key: String, node: Control, mouse_confined: bool = false) -> void:
	menus[key] = [node, mouse_confined]
	node.tree_exiting.connect(_menu_node_exiting.bind(node), CONNECT_ONE_SHOT)

# ======================== PUBLIC FUNCS ========================

func go_to_menu(key: String) -> void:
	if current_menu == key: return
	
	for menu_name: String in menus:
		menus[menu_name][0].visible = menu_name == key
	
	var mouse_mode := Input.MOUSE_MODE_CONFINED
	if menus.has(key):
		if not menus[key][1]:
			mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	Input.mouse_mode = mouse_mode
	current_menu = key

func go_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
	get_tree().paused = false

# ======================== PRIVATE FUNCS ========================

func _menu_node_exiting(node: Control) -> void:
	for menu_name: String in menus:
		if menus[menu_name][0] == node:
			menus.erase(menu_name)
