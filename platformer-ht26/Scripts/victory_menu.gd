extends CanvasLayer

signal change_level


func _ready() -> void:
	hide()

func _on_next_level_button_pressed() -> void:
	emit_signal("change_level")
