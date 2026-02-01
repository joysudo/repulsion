extends Area2D

@export var rotation_speed: float = 1.0
@export_file("*.tscn") var next_level_path: String # hgave to set this in inspector

var players_ready: int = 0
var is_active: bool = false

func _ready():
	scale = Vector2.ZERO
	monitoring = false

func _process(delta: float) -> void:
	$Sprite2D.rotation += rotation_speed * delta
	var coins = get_tree().get_nodes_in_group("coins")
	if coins.size() == 0 and not is_active:
		is_active = true
		monitoring = true
		$GPUParticles2D.emitting = true
	if is_active:
		scale = scale.lerp(Vector2(1, 1), 0.1)

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
