extends CharacterBody2D
class_name Player

const MAX_SPEED = 350
const ACC = 3000
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
	if input_x != 0:
		#Rörelse åt höger eller vänster
		velocity.x = move_toward(velocity.x, input_x * MAX_SPEED, ACC*delta)
	else:
		#ingen input -> stanna
		velocity.x = move_toward(velocity.x, 0, ACC*delta)
	
	velocity.y += GRAVITY*delta #Lägger till gravitation i y-led
	move_and_slide() #utför rörelse enligt velocity-vektor
	

############ STATE FUNCTIONS ######################
func _idle_state(delta: float) -> void:
	#1 check inputs
	if Input.is_action_just_pressed("Jump"):
		_enter_air_state(true)
	var input_x = Input.get_axis("Move left", "Move right")
	
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring
	if not is_on_floor():
		_enter_air_state(false)
	elif velocity.length() != 0:
		_enter_walk_state()

func _walk_state(delta: float) -> void:
	#1 check inputs
	if Input.is_action_just_pressed("Jump"):
		_enter_air_state(true)
	var input_x = Input.get_axis("Move left", "Move right")
	
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring
	if not is_on_floor():
		_enter_air_state(false)
	elif velocity.length() == 0:
		_enter_idle_state()

func _air_state(delta: float) -> void:
	#1 get inputs
	var input_x = Input.get_axis("Move left", "Move right")
	
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring
	if is_on_floor() and velocity.length() > 0:
		_enter_walk_state()
	elif is_on_floor():
		_enter_idle_state()
	

func _edge_state(delta: float) -> void:
	pass

func _dead_state(delta: float) -> void:
	pass


############ ENTER STATE FUNCTIONS ################
func _enter_idle_state() -> void:
	state = IDLE
	anim.play("idle")

func _enter_walk_state() -> void:
	state = WALK
	anim.play("walk")

func _enter_air_state(jumping: bool) -> void:
	state = AIR
	anim.play("air")
	if jumping:
		velocity.y = -JUMP_SPEED

func _enter_edge_state() -> void:
	state = EDGE

func enter_dead_state() -> void:
	state = DEAD

############ SIGNALS ##############################
