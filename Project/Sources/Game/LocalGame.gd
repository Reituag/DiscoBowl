extends Node

var autoCtrlr = preload("res://Sources/Character/AutoController.tscn")

var scene_parameters : Dictionary = {
	"players" : { 'id'        : '',
				  'character' : null}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#############
	# TEST CODE #
	#############
	for i in range(1,6):
		scene_parameters["players"]['id'] = "player{n}".format({'n':i})
		if i != 2:
			var auto = autoCtrlr.instance()
			auto.config("shield")
			$Characters.get_child(i-1).start($Arena.startPoints[i-1], auto)
		else :
			var kbCtrler = load("res://Sources/Character/KeyboardCharacterController.tscn").instance()
			kbCtrler.config() 
			$Characters.get_child(i-1).start($Arena.startPoints[i-1], kbCtrler)
		scene_parameters["players"]["character"] = $Characters.get_child(i-1)
	#############
#	var auto1 = autoCtrlr.instance()
#	auto1.config("shield")#("shoot")
#	$Character.start($Start_L.position, auto1)
#	var auto2 = autoCtrlr.instance()
#	auto2.config("shield")#("shoot")
#	$Character2.start($Start_R.position, auto2)
#	var auto4 = autoCtrlr.instance()
#	auto4.config("shield")#("shoot")
#	$Character4.start($Start_UL.position, auto4)
#	var auto5 = autoCtrlr.instance()
#	auto5.config("shield")#("shoot")
#	$Character5.start($Start_UR.position, auto5)
#
#
#	var kbCtrler = load("res://Sources/Character/KeyboardCharacterController.tscn").instance()
#	kbCtrler.config()
#	$Character3.start($Start_D.position, kbCtrler)


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
