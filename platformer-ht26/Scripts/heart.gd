extends Area2D


signal pickup




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("pickup")
		queue_free()
