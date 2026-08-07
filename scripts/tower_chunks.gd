extends Node2D

@export var chunk_scene: PackedScene
@export var chunk_height: float = 480 # Default dimensions of the game
@export var chunks_ahead: int = 3 # idk I just picked 3 :P

var player: Node2D
var highest_chunk_index: int = 0
var peak_y: float = 0.0
var spawned_chunks: Dictionary = {}
func _ready() -> void:
	# Import autoloaded player variable
	player = game.player
	
	
	for i in range(1,chunks_ahead+1):
		spawn_chunk(i)
		highest_chunk_index = i

func _process(_delta):
	if not player:
		return
	peak_y = min(peak_y, player.global_position.y)
	var peak_chunk_index = int(-peak_y / chunk_height)
	while highest_chunk_index < peak_chunk_index + chunks_ahead:
		highest_chunk_index += 1
		spawn_chunk(highest_chunk_index)

func spawn_chunk(index: int) -> void:
	if spawned_chunks.has(index):
		return
	var chunk = chunk_scene.instantiate()
	chunk.position = Vector2(0, -index * chunk_height)
	add_child(chunk)
	spawned_chunks[index] = chunk

	if chunk.has_method("populate"):
		chunk.populate()
