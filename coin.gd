extends Area2D

signal collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Coin touched by:", body.name)
	if body.is_in_group("player"):
		emit_signal("collected")
		queue_free()
