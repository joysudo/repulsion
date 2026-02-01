# this script is the one that
# even if visual line is not needed 
extends Line2D

@export var p1: CharacterBody2D
@export var p2: CharacterBody2D
const force_strength = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if p1.current_charge != 0 and p2.current_charge != 0:
		show()
		points = PackedVector2Array([to_local(p1.global_position), to_local(p2.global_position)])
		calculate_magnetism()
	else:
		hide()
	if (p2.global_position - p1.global_position).length() > 301: 
		hide() 

func calculate_magnetism():
	var p1_supported = p1.is_supported_by_world()
	var p2_supported = p2.is_supported_by_world()
	var mutually_airborne = not p1_supported and not p2_supported

	
	const MAX_DISTANCE = 301
	const MIN_DISTANCE = 100 # idk. was going to make this the length of player but this just works b etter
	var dist_vect = p2.global_position - p1.global_position
	var distance = clamp(dist_vect.length(), MIN_DISTANCE, MAX_DISTANCE)

	if distance > MAX_DISTANCE or distance < 100: 
		return # if too far or close, don't calculate attraction
	
	if mutually_airborne and p1.current_charge * p2.current_charge == -1:
		return
	
	var direction = dist_vect.normalized()
	#if direction.y < 0.5 and !(p1.current_charge * p2.current_charge):
		#direction.x *= 2
		#direction = direction.normalized()
	
	# trying to add a min distance to denominator to stop force from exploding
	var force
	if p1.current_charge * p2.current_charge == 1: # repel
		force = direction * force_strength * 10000 / (distance + MIN_DISTANCE) * clamp(1.0-(distance/MAX_DISTANCE), 0.0, 1.0)
		p1.external_velocity -= force
		p2.external_velocity += force
	else: # if == -1, attract
		force = direction * force_strength * 7000 / (distance + MIN_DISTANCE) * clamp(1.0-(distance/MAX_DISTANCE), 0.0, 1.0)
		p1.external_velocity += force
		p2.external_velocity -= force
