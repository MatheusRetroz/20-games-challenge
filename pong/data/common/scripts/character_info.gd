@tool extends Resource
class_name CharacterInfo


@export_file_path() var model: String = ""

@export_group("Icons")
@export var normal_icon: Texture = null
@export var damage_icon: Texture = null
@export var dead_icon: Texture = null

@export_group("Stats")
@export var max_heath: float = 100.00
@export var current_heath: float = 100.00
@export var max_stamina: float = 100.00
@export var current_stamina: float = 100.00
@export var stamina_regen_rate: float = 1.0
@export var stamina_cost_rate: float = 1.0
