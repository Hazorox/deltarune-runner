extends Area2D
@onready var launch_speed = 767 # Im brain rotted, HELP
@onready var cooldown = 0.35
@onready var flower_sprite = $AnimatedSprite2D
var can_slash = true
var inside:Node2D = null
var was_above = false
func _process(_delta:float)->void:
	if game.player!=null:
		if game.player.global_position.y>global_position.y and was_above:
			game.tower_score-=1
			was_above=false
		if game.player.global_position.y < global_position.y and not was_above :
			game.tower_score+=1
			game.tower_hi = max(game.tower_hi,game.tower_score)
			was_above=true
		
func launch_player(player: Node2D) -> void:
	can_slash = false
	flower_sprite.play("hit")
	var raw_direction = (player.global_position - global_position).normalized()
	var snapped_direction = snap_dir(raw_direction)
	player.apply_launch(snapped_direction * launch_speed)
	await get_tree().create_timer(cooldown).timeout
	can_slash = true

func snap_dir(dir: Vector2) -> Vector2:
	var angle = dir.angle()
	var snapped_angle = round(angle / (PI / 4.0)) * (PI / 4.0)
	return Vector2(cos(snapped_angle), sin(snapped_angle))

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
