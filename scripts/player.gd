extends CharacterBody2D
class_name PlayerSnapshot

const SPEED := 350.0
const JUMP_VELOCITY := -650.0
var launch_lock := false
var launch_lock_time := 0.25
var was_landed := true
var history := []
@onready var sprite := $sprite
@onready var collision := $collision
func _ready()->void:
	game.player=self
func _physics_process(delta: float) -> void:
	history.push_front({
		"pos": global_position,
		"facing": sprite.flip_h,
		"anim": sprite.animation,  # "idle", "run", etc.
	})
	if history.size() > 10:
		history.pop_back()
	if Input.is_action_just_pressed("accept") and not get_meta("slashing", false) and not is_on_floor():
		set_meta("slashing", true)
		sprite.play("slash_air")
		for flower in get_tree().get_nodes_in_group("flower"):
			if flower.inside == self:
				flower.attempt_launch()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	
	# Flip direction
	if not launch_lock:
		if direction:
			if direction==1.0:
				sprite.flip_h=false
			elif direction==-1.0:
				sprite.flip_h=true
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Change frames
	if not get_meta("slashing",false):
		if velocity.y>0:
			sprite.play("down")
		elif velocity.y<0:
			sprite.play("up")
		elif velocity.x!=0:
			sprite.play("run")
		else:
			if sprite.animation !="land":
				sprite.play("idle")
	move_and_slide()
	
	# Playing the 'land' animation on falling to the floor
	var land_now = is_on_floor()
	var just_landed = land_now and not was_landed
	if just_landed:
		sprite.play("land")
	was_landed = land_now
func _on_sprite_animation_finished() -> void:
	if sprite.animation == "slash_air":
		set_meta("slashing",false)
	if sprite.animation == "land":
		sprite.play("idle")

func apply_launch(vel: Vector2) -> void:
	velocity = vel
	launch_lock = true
	get_tree().create_timer(launch_lock_time).timeout.connect(func(): launch_lock = false)
	return
