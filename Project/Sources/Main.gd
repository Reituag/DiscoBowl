extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	var kbCtrler = load("res://Sources/Character/KeyboardCharacterController.tscn").instance()
	kbCtrler.config('azerty')
	$Character.myController = kbCtrler
	$Character.start($StartPosition.position)
	
	var joyCtrler = load("res://Sources/Character/JoypadCharacterController.tscn").instance()
	joyCtrler.config(0)
	$Character2.myController = joyCtrler
	$Character2.start($StartPosition2.position)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
