extends CharacterBody2D
class_name Player

const MAX_SPEED = 350
const ACC = 2000
const JUMP_SPEED = 700
const GRAVITY = 1500

enum{IDLE, WALK, AIR, EDGE, DEAD}

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var state = IDLE

############# GAME LOOP ###########################
func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)
		AIR:
			_air_state(delta)
		EDGE:
			_edge_state(delta)
		DEAD:
			_dead_state(delta)


############ PRIVATE HELP FUNCTIONS ###############
func _update_direction(input_x: float) -> void:
	if input_x < 0:
		sprite.flip_h = true
	elif input_x > 0:
		sprite.flip_h = false

func _movement(input_x: float, delta: float) -> void:
	"""
	UPPGIFT: Utför en rörelse, velocity.x anger spelarens hastighet i x-led. 
	Se även till att lägga till gravitation i y-led.
	move_and_slide() genomför själva rörelsen och anropas sist. 
	"""
	pass

############ STATE FUNCTIONS ######################
func _idle_state(delta: float) -> void:
	#1 check inputs
	if Input.is_action_just_pressed("Jump"):
		_enter_air_state()
	var input_x = Input.get_axis("Move left", "Move right")
	
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring

func _walk_state(delta: float) -> void:
	pass

func _air_state(delta: float) -> void:
	pass

func _edge_state(delta: float) -> void:
	pass

func _dead_state(delta: float) -> void:
	pass


############ ENTER STATE FUNCTIONS ################
func _enter_idle_state() -> void:
	pass

func _enter_walk_state() -> void:
	pass

func _enter_air_state() -> void:
	pass

func _enter_edge_state() -> void:
	pass

func enter_dead_state() -> void:
	pass

############ SIGNALS ##############################
