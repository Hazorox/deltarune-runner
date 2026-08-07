extends Area2D
# Constants
@onready var launch_speed:int
@onready var cooldown = 0.35
# Resources
@onready var flower_sprite:AnimatedSprite2D = $spriteFrames
@onready var directed_flower = preload("res://resources/pusher_directed.tres")
@onready var auto_flower = preload("res://resources/pusher_auto.tres")
# Score and slashing
var can_slash = true
var inside:Node2D = null
var was_above = false

# Initialize based on difficulty
func _ready()->void:
	match game.difficulty:
		# EASY
		0:
			launch_speed = 700
			flower_sprite.sprite_frames = directed_flower
			match name:
				"left":
					flower_sprite.animation = "idle_topright"
				"right":
					flower_sprite.animation = "idle_topleft"
		# Normal
		1:
			launch_speed=767
			flower_sprite.sprite_frames = auto_flower
			flower_sprite.animation = "idle"

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
	
	# Put on cooldown
	can_slash = false
	
	# Play Animation based on difficulty for each idk
	match game.difficulty:
		0:
			match name:
				"left":
					flower_sprite.play("hit_topright")
				"right":
					flower_sprite.play("hit_topleft")
		1:
			flower_sprite.play("hit")
	# Some vector idk
	var raw_direction = (player.global_position - global_position).normalized()
	var snapped_direction = snap_dir(raw_direction)
	
	# LAUNCH THAT BAD BOY
	player.apply_launch(snapped_direction * launch_speed)
	
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
