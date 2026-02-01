extends Camera2D

@onready var p1 = $"../Player1"
@onready var p2 = $"../Player2"
@onready var tilemap = $"../TileMapLayer"

const min_zoom = 1.0
const zoom_threshold = 150.0
const max_dist = 1700.0
const default_zoom = 1.2

func _ready() -> void:
	print(p1)
	print(p2)
	if tilemap:
		var map_rect = tilemap.get_used_rect()
		var tile_size = tilemap.tile_set.tile_size
		limit_left = map_rect.position.x * tile_size.x + 10
		limit_right = map_rect.end.x * tile_size.x  - 10
		limit_top = map_rect.position.y * tile_size.y - 60
		limit_bottom = map_rect.end.y * tile_size.y - 10
		offset = Vector2.ZERO

func _process(_delta: float) -> void:
	if is_instance_valid(p1) and is_instance_valid(p2):
		var target_pos = (p1.global_position + p2.global_position) / 2.0
		global_position = global_position.lerp(target_pos, 0.1)
		# zoom
		var dist = p1.global_position.distance_to(p2.global_position)
		var zoom_target = default_zoom
		if dist > zoom_threshold:
			zoom_target = remap(dist, zoom_threshold, max_dist, default_zoom, min_zoom)
		zoom_target = clamp(zoom_target, min_zoom, default_zoom)
		zoom = zoom.lerp(Vector2(zoom_target, zoom_target), 0.05)
	elif is_instance_valid(p2):
		global_position = global_position.lerp(p2.global_position, 0.1)
	elif is_instance_valid(p1):
		global_position = global_position.lerp(p2.global_position, 0.1)
