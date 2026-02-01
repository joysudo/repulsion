extends Area2D

@onready var sfx = $AudioStreamPlayer2D
signal collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("collected")
		sfx.pitch_scale = randf_range(1.10, 2.30)
		sfx.play()
		visible = false
		set_deferred("monitoring", false)
		await sfx.finished
		queue_free()
