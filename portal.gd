extends Area2D

@export var rotation_speed: float = 1.0
@export_file("*.tscn") var next_level_path: String # hgave to set this in inspector

var players_ready: int = 0
	
func _process(delta: float) -> void:
	$Sprite2D.rotation += rotation_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		handle_player_entry(body)

func handle_player_entry(player: Node2D) -> void:
	players_ready += 1
	player.hide()
	player.process_mode = Node.PROCESS_MODE_DISABLED
	for child in player.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	if players_ready >= 2:
		change_level()

func change_level() -> void:
	if next_level_path == "":
		print("no next level path set in portal's inspector!")
		return
		
	get_tree().change_scene_to_file(next_level_path)
