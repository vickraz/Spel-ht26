extends CharacterBody2D
class_name Enemy

const WALK_SPEED = 100
const GRAVITY = 1000

@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var turn_cooldown: Timer = $TurnCooldown
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var dir: int = 1
var can_turn = true

func _is_on_edge() -> bool:
	left_ray.force_raycast_update()
	right_ray.force_raycast_update()
	return not(left_ray.is_colliding() and right_ray.is_colliding())


func _physics_process(delta: float) -> void:
	
	velocity.x = dir * WALK_SPEED
	velocity.y += GRAVITY * delta
	move_and_slide()
	if _is_on_edge() and can_turn:
		dir *= -1
		can_turn = false
		turn_cooldown.start()
		animated_sprite_2d.flip_h = not(animated_sprite_2d.flip_h)
		


func _on_turn_cooldown_timeout() -> void:
	can_turn = true


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
