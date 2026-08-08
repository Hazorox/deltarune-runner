extends Node
@onready var fullscreen:bool=false
@onready var tower_score:int = 0
@onready var tower_hi:int = 0
@onready var mode = null
@onready var paused = false
@onready var level_chosen:bool = false
enum difficulties {easy,normal,hard}
@onready var difficulty = difficulties.normal
var player:Node2D = null
signal difficulty_chosen
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
func _process(delta: float) -> void:
	# Listen for full screen
	if Input.is_action_just_pressed("fullscreen"):
		# Toggle Based on Boolean
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen=false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen=true
	# Listen for Exit
	elif Input.is_action_just_pressed("exit"):
		if game.paused:
			get_tree().paused=false
			game.paused=false
		else:
			get_tree().paused = true
			game.paused=true
func pause(idk:bool)->void:
	if idk:
		get_tree().paused = true
		paused = true
	else:
		paused = false
		get_tree().paused = false
