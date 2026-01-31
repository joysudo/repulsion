extends CharacterBody2D

@export var player_id: int
@export var current_charge: int = 0 # -1, 0, 1
@onready var sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const MAGNETIC_FORCE = 200.0
var external_velocity = Vector2.ZERO

func _ready() -> void:
	update_animation(Vector2.ZERO)

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# handle all player inputs
	var move_left = "a" if player_id == 1 else "left"
	var move_right = "d" if player_id == 1 else "right"
	var jump_action = "w" if player_id == 1 else "up"
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# cfalc player movements
	var direction := Input.get_axis(move_left, move_right)
	velocity.x = direction * SPEED
	velocity += external_velocity
	# move player
	move_and_slide()
	update_animation(velocity)
	external_velocity = Vector2.ZERO 

func update_animation(velocity: Vector2):
	var state = ""
	var charge_suffix = ""
	if not is_on_floor():
		state = "jump"
	elif abs(velocity.x) > 0.1:
		state = "run"
	else: 
		state = "idle"
	match current_charge:
		-1: charge_suffix = "_neg"
		0: charge_suffix = "_neu"
		1: charge_suffix = "_pos"
	sprite.play(state + charge_suffix)
