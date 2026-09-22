extends Area2D

signal activated(pos, name)

var is_activated: bool = false


func deactivate() -> void:
	#Anropas av level
	is_activated = false
	$AnimatedSprite2D.play("not active")

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not is_activated:
		is_activated = true
		$AnimatedSprite2D.play("active")
		emit_signal("activated", global_position, name)
