extends Line2D

@export var p1: CharacterBody2D
@export var p2: CharacterBody2D
@export var force_strength: float = 5.0 #idfk

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if p1.current_charge != 0 and p2.current_charge != 0:
		show()
		points = PackedVector2Array([to_local(p1.global_position), to_local(p2.global_position)])
		calculate_magnetism()
	else:
		hide()

func calculate_magnetism():
	var direction = p1.global_position.direction_to(p2.global_position)
	var distance = p1.global_position.distance_to(p2.global_position)
	if distance < 20: return #this is an arbitrary number, but need to prevent extreme forces
	
	var charge_product = p1.current_charge * p2.current_charge
	var force = (direction * force_strength * 1000) / distance
	if charge_product == 1: # repel
		p1.external_velocity -= force
		p2.external_velocity += force
	else: # if == -1, attract
		p1.external_velocity += force
		p2.external_velocity -= force

# make it so distance radius is taken more into account when considering force
