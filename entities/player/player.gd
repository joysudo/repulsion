extends CharacterBody2D

@export var player_id: int
@export var current_charge: int = 0 # -1, 0, 1
@onready var sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const MAGNETIC_FORCE = 50.0
var external_velocity = Vector2.ZERO

func _ready() -> void:
	update_animation(Vector2.ZERO)
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# handle jump
	var jump_action = "w" if player_id == 1 else "up"
	if Input.is_action_just_pressed(jump_action) and can_jump():
		velocity.y = JUMP_VELOCITY
	# handle horizontal movement
	var move_left = "a" if player_id == 1 else "left"
	var move_right = "d" if player_id == 1 else "right"
	var direction := Input.get_axis(move_left, move_right)
	# set x directly, while y is just added to with gravity
	velocity.x = direction * SPEED
	# apply magnetism
	velocity += external_velocity * 60 * delta
	# move player
	#if not is_supported_by_world():
		#if velocity.y < 0:
			#velocity.y = max(velocity.y, get_gravity().y * delta)
	move_and_slide()
	update_animation(velocity)
	external_velocity = Vector2.ZERO 
	# update charge
	var charge_action = "e" if player_id == 1 else "right_shift"
	if Input.is_action_just_pressed(charge_action):
		toggle_charge()

func update_animation(velocity_vec: Vector2):
	var state = ""
	var charge_suffix = ""
	# determine state
	if not is_on_floor(): state = "jump"
	elif abs(velocity_vec.x) > 0.1: state = "run"
	else: state = "idle"
	# flip
	var move_left = "a" if player_id == 1 else "left"
	var move_right = "d" if player_id == 1 else "right"
	var input_direction = Input.get_axis(move_left, move_right)
	if input_direction < 0: sprite.flip_h = true
	elif input_direction > 0: sprite.flip_h = false
	# pick animation
	match current_charge:
		-1: charge_suffix = "_neg"
		0: charge_suffix = "_neu"
		1: charge_suffix = "_pos"
	
	# if color change is happening dont play the other animations
	if animation_player.is_playing() and animation_player.current_animation == "color_change":
		return
	
	sprite.play(state + charge_suffix)
	animation_player.play(state)

func can_jump():
	if $CeilingChecker.is_colliding():
		if $CeilingChecker.get_collider() is CharacterBody2D:
			return false
	if is_on_floor():
		return true
	if $FloorChecker.is_colliding():
		if $FloorChecker.get_collider() is CharacterBody2D:
			return true
	return false 

func toggle_charge():
	animation_player.play("color_change")
	print("hi")
	# this would be cleaner with an array and modulo but it is not complex= enough to require that LOL
	if current_charge == -1:
		current_charge = 0
	elif current_charge == 0:
		current_charge = 1
	else:
		current_charge = -1

func is_supported_by_world() -> bool:
	if is_on_floor():
		return true
	if $FloorChecker.is_colliding():
		var c = $FloorChecker.get_collider()
		return not (c is CharacterBody2D)
	return false
