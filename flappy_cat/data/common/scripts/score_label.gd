extends Label
class_name ScoreLabel


@export var high_score: bool = false
@export var new_score_label: Label = null

# [NATIVE] -----------------------------------------------------------------------------------------
func _ready() -> void:
	if new_score_label:
		new_score_label.visible = false
	if high_score:
		text = str(MainCore.high_score)
		MainCore.high_score_changed.connect(_on_high_score_changed)
	else:
		text = str(MainCore.score)
		MainCore.score_changed.connect(_on_score_changed)

# [SIGNAL] -----------------------------------------------------------------------------------------
func _on_score_changed(value: int) -> void:
	text = str(value)

# --------------------------------------------------------------------------------------------------
func _on_high_score_changed(value: int) -> void:
	text = str(value)
	if new_score_label:
		new_score_label.visible = true
