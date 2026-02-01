extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("coin")
	pass # Replace with function body.

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("coin_collected")
		queue_free()
