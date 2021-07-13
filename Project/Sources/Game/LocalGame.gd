extends Node

var scene_parameters : Dictionary = {
	"players" : [{ 'id'         : 'Player1',
					'controller': 'autoshield',
					'character' : null},
				{ 'id'          : 'Player2',
					'controller': 'k0',
					'character' : null},
				{ 'id'          : 'Player3',
					'controller': 'autoshield',
					'character' : null},
				{ 'id'         : 'Player4',
					'controller': 'autoshield',
					'character' : null},
				{ 'id'         : 'Player5',
					'controller': 'j0',
					'character' : null} ]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#############
	# TEST CODE #
	#############
	for i in range(5):
		var player_data = { 'id'        : 'Gurlu',
							'controller': 'none',
							'character' : null}
		player_data['id'] = "player{n}".format({'n':i})
		if i != 1:
			var auto = AutoController.new()
			auto.config("shield")
			$Characters.get_child(i).start($Arena.startPoints[i], auto)
			player_data['controller'] = auto
		else :
			var kbCtrler = KeyboardCharacterController.new()
			kbCtrler.config() 
			$Characters.get_child(i).start($Arena.startPoints[i], kbCtrler)
			player_data['controller'] = kbCtrler
		
		if scene_parameters.size() > i:
			scene_parameters["players"][i] = player_data
		else:
			scene_parameters['players'].append(player_data)
		scene_parameters["players"][i]["character"] = $Characters.get_child(i)
	#############


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
