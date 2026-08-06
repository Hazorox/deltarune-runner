extends Node
@onready var fullscreen:bool=false
@onready var tower_score:int = 0
@onready var tower_hi:int = 0
var player:Node2D = null

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
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
