extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	var kbCtrler = load("res://Sources/Character/KeyboardCharacterController.tscn").instance()
	kbCtrler.config()
	$Character.start($StartPosition.position, kbCtrler)
	
	var joyCtrler = load("res://Sources/Character/JoypadCharacterController.tscn").instance()
	joyCtrler.config(0) 
	$Character2.start($StartPosition2.position, joyCtrler)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
