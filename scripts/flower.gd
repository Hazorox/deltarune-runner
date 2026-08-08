extends Area2D
# Constants
@onready var launch_speed:int = 767
@onready var cooldown = 0.35
# Resources
@onready var flower_sprite:AnimatedSprite2D = $spriteFrames
@onready var collision_shape:CollisionShape2D = $CollisionShape2D
var directed_flower = preload("res://resources/pusher_directed.tres")
var auto_flower = preload("res://resources/pusher_auto.tres")
# Score and slashing
var can_slash = true
var inside:Node2D = null
var was_above = false

# Initialize based on difficulty
func _ready()->void:
	if not game.level_chosen:
		await game.difficulty_chosen
	match game.difficulty:
		# EASY
		0:
			launch_speed=1000
			collision_shape.shape.radius = 25
			flower_sprite.sprite_frames = directed_flower
			match name:
				"left":
					global_position.x = 135
					flower_sprite.animation = "idle_topright"
				"right":
					global_position.x=500
					flower_sprite.animation = "idle_topleft"

# Update score based on player y
func _process(_delta:float)->void:
	if game.player!=null:
		if game.player.global_position.y>global_position.y and was_above:
			game.tower_score-=1
			was_above=false
		if game.player.global_position.y < global_position.y and not was_above :
			game.tower_score+=1
			game.tower_hi = max(game.tower_hi,game.tower_score)
			was_above=true

# Launch player on hit
func launch_player(player: Node2D) -> void:
	var direction
	# Put on cooldown
	can_slash = false
	
	# Play Animation based on difficulty for each idk
	match game.difficulty:
		0:
			match name:
				"left":
					flower_sprite.play("hit_topright")
					direction = Vector2(1,-1).normalized()
				"right":
					flower_sprite.play("hit_topleft")
					direction = Vector2(-1,-1).normalized()
		1:
			flower_sprite.play("hit")
			# Some vector idk
			var raw_direction = (player.global_position - global_position).normalized()
			direction = snap_dir(raw_direction)
	
	# LAUNCH THAT BAD BOY
	player.apply_launch(direction * launch_speed)
	
	# Apply cooldown
	await get_tree().create_timer(cooldown).timeout
	can_slash = true

# Some formula to calc speed and direction ( thx Claude :heart: )
func snap_dir(dir: Vector2) -> Vector2:
	var angle = dir.angle()
	var snapped_angle = round(angle / (PI / 4.0)) * (PI / 4.0)
	return Vector2(cos(snapped_angle), sin(snapped_angle))


# Check conditions then launch if met
func attempt_launch()->void:
	if not can_slash or inside == null:
		return
	launch_player(inside)
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside=body

func _on_body_exited(body: Node2D) -> void:
	if body == inside:
		inside=null
