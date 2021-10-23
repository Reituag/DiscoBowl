extends Node

var scene_parameters : Dictionary = {
	"players" : [{ 'id'         : 'Player1',
					'controller': 'autoshield'},
				{ 'id'          : 'Player2',
					'controller': 'k0'},
				{ 'id'          : 'Player3',
					'controller': 'autoshield'},
				{ 'id'         : 'Player4',
					'controller': 'autoshield'},
				{ 'id'         : 'Player5',
					'controller': 'j0'} ]
}

onready var arena : Map = $Arena
onready var endMenu : PopupDialog = $EndMenu
onready var quitButton : Button = $EndMenu/VBoxContainer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	
	quitButton.connect("pressed", self, "_onQuitButtonPressed")
	
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
			
			# Setting character name
			character.set_name(players[index]['id'])
			
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
			
			# Connecting character death signal to the game in order to remove 
			# dead characters and handle end of game
			character.connect("die", self, "_onCharacterDie", [character])
			
			# Start character
			character.start(arena.startPoints[index], controller)
			
			# Addition of a status for each player
			scene_parameters['players'][index]['status'] = 'alive'
		else:
			# Error information
			print("Only {2} start points: n°{0}/{1} not added".format( 
				[index, players.size(), arena.startPoints.size()]))
	
	# Deletion of extra-players info. Allows to re-use scene_parameters later
	# for example, know which players are still alive
	if players.size() > arena.startPoints.size():
		scene_parameters['players'].resize(arena.startPoints.size())

func _input(event):
	# Pause game on associated event
	if event.is_action_pressed("pause_game"):
		# Verifies emitting device: unconnected devices can't pause the game
		if event is InputEventJoypadButton or event is InputEventKey:
			var device = ''
			if event is InputEventJoypadButton:
				device = "j" + str(event.device)
			elif event is InputEventKey:
				device = "k" + str(event.device)
			for p in scene_parameters['players']:
				if p['controller'] == device:
					get_tree().quit() # TODO: change with pause menu

func _onCharacterDie(character):
	if character != null:
		# Removing character
		remove_child(character)
		
		# Character marking as dead and looking for alive characters
		var index_alive
		var alive_count = 0
		for player in scene_parameters['players']:
			if player['id'] == character.myName:
				player['status'] = 'dead'
				print(scene_parameters)
				
			if player['status'] == 'alive':
				index_alive = scene_parameters['players'].find(player)
				alive_count += 1
				
		if alive_count == 1:
			endGame(index_alive)

func endGame(winner_index):
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	move_child(endMenu, get_children().size())
	endMenu.show()

func _onQuitButtonPressed():
#	get_tree().change_scene_to(Global.mainMenu)
	get_tree().quit()
