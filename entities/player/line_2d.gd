extends Line2D

@export var p1: CharacterBody2D
@export var p2: CharacterBody2D
const force_strength = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if p1.current_charge != 0 and p2.current_charge != 0:
		show()
		points = PackedVector2Array([to_local(p1.global_position), to_local(p2.global_position)])
		calculate_magnetism()
	else:
		hide()

func calculate_magnetism():
	const MAX_DISTANCE = 201
	const MIN_DISTANCE = 200 # make this the length of player
	var dist_vect = p2.global_position - p1.global_position
	var distance = clamp(dist_vect.length(), MIN_DISTANCE, MAX_DISTANCE)

	if distance > MAX_DISTANCE: return # if too far or close, don't calculate attraction
	
	var direction = dist_vect.normalized()
	# trying to add a min distance to denominator to stop force from exploding
	var force = direction * force_strength * 10000 / (distance + MIN_DISTANCE) * clamp(1.0-(distance/MAX_DISTANCE), 0.0, 1.0)
	#if abs(direction.y) > 0.5:
		#force.y *= 0.2
		#force.y = clamp(force.y, -1, 1)
	
	if p1.current_charge * p2.current_charge == 1: # repel
		p1.external_velocity -= force
		p2.external_velocity += force
	else: # if == -1, attract
		p1.external_velocity += force
		p2.external_velocity -= force
