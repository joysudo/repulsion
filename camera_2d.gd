extends Camera2D

@onready var p1 = $"../Player1"
@onready var p2 = $"../Player2"

func _process(_delta: float) -> void:
	if is_instance_valid(p1) and is_instance_valid(p2):
		global_position = (p1.global_position + p2.global_position) / 2.0
		global_position.y -= 200
		global_position.x += 100
