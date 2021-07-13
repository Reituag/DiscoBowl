extends Node

var reticule = load("res://Art/Disc/reticule32.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
#	Input.set_custom_mouse_cursor(reticule, 0, Vector2(0.1, 0.1))

func new_game():
	var kbCtrler = KeyboardCharacterController.new()#load("res://Sources/Character/KeyboardCharacterController.tscn").instance()
	kbCtrler.config()
	$Character.start($StartPosition.position, kbCtrler)
	
#	var joyCtrler = 
#	joyCtrler.config(0) 
#	$Character2.start($StartPosition2.position, joyCtrler)
	
	var autoCtrler = AutoController.new()
	autoCtrler.config("shoot")#("shield")
	$Character2.start($StartPosition2.position, autoCtrler)
	

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
