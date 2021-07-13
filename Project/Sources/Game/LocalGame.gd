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

onready var arena : Map = $Arena

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var players = scene_parameters['players']
	# Characters & Controllers instanciation
	for index in range(players.size()):
		if index in range(arena.startPoints.size()):
			# Character instanciation & addition to childs
			# if the ressource is given in parameters, various characters 
			# can be loaded
			var character = \
				load("res://Sources/Character/Character.tscn").instance()
			add_child(character)
			
			# Controller instanciation & configuration
			var controller
			if 'auto' in players[index]['controller']:
				# Auto Controller configuration
				controller = AutoController.new()
				controller.config(players[index]['controller'])
			elif 'k' in players[index]['controller']:
				# Keyboard controller configuration
				controller = KeyboardCharacterController.new()
				controller.config()
			elif 'j' in players[index]['controller']:
				# Joypad controller configuration.
				# Device index is given in the controller indicator : 
				# j3 is joypad controller, device number 3
				controller = JoypadCharacterController.new()
				controller.config(int(players[index]['controller'].substr(1)))
			else:
				# Default controller is an autocontroller with shielding
				controller = AutoController.new()
				controller.config('shield')
			# Start character
			character.start(arena.startPoints[index], controller)
		else:
			# Error information
			print("Only {2} start points: n°{0}/{1} not added".format( 
				[index, players.size(), arena.startPoints.size()]))

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
