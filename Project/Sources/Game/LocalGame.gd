extends Node

var autoCtrlr = preload("res://Sources/Character/AutoController.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var auto1 = autoCtrlr.instance()
	auto1.config("shield")#("shoot")
	$Character.start($Start_L.position, auto1)
	var auto2 = autoCtrlr.instance()
	auto2.config("shield")#("shoot")
	$Character2.start($Start_R.position, auto2)
	var auto4 = autoCtrlr.instance()
	auto4.config("shield")#("shoot")
	$Character4.start($Start_UL.position, auto4)
	var auto5 = autoCtrlr.instance()
	auto5.config("shield")#("shoot")
	$Character5.start($Start_UR.position, auto5)
	
	
	var kbCtrler = load("res://Sources/Character/KeyboardCharacterController.tscn").instance()
	kbCtrler.config()
	$Character3.start($Start_D.position, kbCtrler)


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
