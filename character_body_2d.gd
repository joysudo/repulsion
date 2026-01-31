extends CharacterBody2D

@export var player_id: int
@export var current_charge: int = 0 # -1, 0, 1

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const MAGNETIC_FORCE = 200.0

var external_velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var move_left = "a" if player_id == 1 else "left"
	var move_right = "d" if player_id == 1 else "right"
	var jump_action = "w" if player_id == 1 else "up"
	
	# Handle jump.
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(move_left, move_right)
	velocity.x = direction * SPEED
	velocity += external_velocity

	move_and_slide()
	
	# external velocity needs to decrease. 20 is an arbitrary number
	#external_velocity = external_velocity.move_toward(Vector2.ZERO, 20)
	external_velocity = Vector2.ZERO
