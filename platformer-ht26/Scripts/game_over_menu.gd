extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
