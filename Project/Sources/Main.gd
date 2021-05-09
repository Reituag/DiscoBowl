extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	$Character.start($StartPosition.position)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
