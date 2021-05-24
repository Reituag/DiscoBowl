extends Node


var reticule = load("res://Art/Disc/reticule32.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	Input.set_custom_mouse_cursor(reticule, 0, Vector2(0.1, 0.1))

func new_game():
	$Character.start($StartPosition.position)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
