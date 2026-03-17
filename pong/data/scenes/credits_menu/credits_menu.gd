extends Control


# ------------------------ EXPORT ------------------------

@export_group("Text")
@export_multiline() var text: String = ""
@export_subgroup("Font Sizes")
@export var title_font_size: float = 36.0
@export var name_font_size: float = 16.0
@export_subgroup("Colors")
@export var title_font_color := Color(0.91, 0.322, 0.376, 1.0)
@export var name_font_color := Color(1.0, 1.0, 1.0, 0.5)

@export_group("Nodes")
@export var rich_text_label: RichTextLabel = null
@export var back_button: BaseButton = null


# ======================== INIT ========================

func _ready() -> void:
	_translate()
	
	if not Engine.is_editor_hint():
		MainCore.set_menu(&"credits", self)
		back_button.pressed.connect(_on_back_button)

# ======================== PRIVATE FUNCS ========================

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		_translate()

func _translate() -> void:
	var base_text: String = text
	var regex := RegEx.new()
	
	base_text = _inset_text(regex, base_text, "credits.title.[A-Za-z0-9_]+", "")
	base_text = _inset_text(regex, base_text, "title_size", str(title_font_size))
	base_text = _inset_text(regex, base_text, "name_size", str(name_font_size))
	base_text = _inset_text(regex, base_text, "title_color", title_font_color.to_html())
	base_text = _inset_text(regex, base_text, "name_color", name_font_color.to_html())
	
	rich_text_label.text = base_text

func _inset_text(regex: RegEx, base_text: String, key: String, value: String) -> String:
	regex.compile(key)
	var pattern_count: int = regex.search_all(base_text).size()
	for i: int in range(pattern_count):
		var result: RegExMatch = regex.search(base_text)
		base_text = _format_text(result, base_text, value if value != "" else tr(result.get_string()))
	return base_text

func _format_text(result: RegExMatch, base_text: String, string: String) -> String:
	base_text = base_text.erase(result.get_start(), result.get_string().length())
	return base_text.insert(result.get_start(), string)

# ======================== SIGNALS ========================

func _on_back_button() -> void:
	if visible: MainCore.go_to_menu(&"main")
