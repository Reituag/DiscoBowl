extends ScrollContainer

# Scenes Import
var char_selec = preload("res://Sources/UI/CharacterSelection/CharacterSelector.tscn")
var ctrl_indic = preload("res://Sources/UI/CharacterSelection/ControllerIndicator.tscn")

# VBox of the controller list
onready var ctrler_list : VBoxContainer = $HBoxContainer/Controllers/VBoxContainer/List

# Matrix of controller indicators
# Lines are indexed with keyboard and joypad, colums with player.
# Column 0 beeing reserved for the controller list
# example of value
# { 'k0' : [Obj123, Obj134, Obj145],
#   'j0' : [Obj223, Obj234, Obj245] }
var ui_matrix = {}
# Memorization of the coordonates of each controller
# example of value 
# { 'k0' : 0,
#   'j0' : 1,
#   'j1' : 2,
#   'j2' : 0 }
var ctrlers_coord = {}

export var nb_players = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	# Matrix of controller indicators creation
	var nb_kboards = 1
	var nb_ctrlers = Input.get_connected_joypads().size()
	
	var players_list = []
	for i in nb_players:
		var charSelect = char_selec.instance()
		charSelect.character_name = "Player {n}".format({'n':i+1})
		$HBoxContainer.add_child(charSelect)
		players_list.append(charSelect)
	
	for i in range(nb_kboards):
		# First column : controller list
		# Index creation
		var index = 'k{n}'.format({'n':i})
		create_ctrl_indic(index, true, false, ctrler_list)
		# Addition in the coordinates memorization 
		ctrlers_coord[index] = 0
		
		# Other columns, number of player dependant
		for j in nb_players:
			create_ctrl_indic(index, true, true, players_list[j].get_list())
		
		
	for i in range(nb_ctrlers):
		# First column : controller list
		# Index creation
		var index = 'j{0}'.format([i])
		create_ctrl_indic(index, false, false, ctrler_list)
		# Addition in the coordinates memorization 
		ctrlers_coord[index] = 0
		
		# Other columns, number of player dependant
		for j in nb_players:
			create_ctrl_indic(index, false, true, players_list[j].get_list())


# Function allowing to create a controller indicator, configurate it and add it
# as a child of a given node.
# Used to instanciate every controller indicator at creating this menu.
func create_ctrl_indic(index, is_keyboard, is_empty, parentNode : VBoxContainer):
	# controller indicator instanciation
	var indic = ctrl_indic.instance()
	# Configuration : joypad and visible
	indic.is_keyboard = is_keyboard
	indic.is_empty = is_empty
	# Addition of the display matrix
	if ui_matrix.has(index):
		ui_matrix[index].append(indic)
	else:
		ui_matrix[index] = [indic]
	parentNode.add_child(indic)


func _input(event):
	if event.is_action_pressed("ui_right"):
		var index = get_device_index(event)
		if index != '':
			move_controller(index, +1)
	elif event.is_action_pressed("ui_left"):
		var index = get_device_index(event)
		if index != '':
			move_controller(index, +1)

func get_device_index(event):
	if event is InputEventKey:
		return 'k{0}'.format([event.device])
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return 'j{0}'.format([event.device])
	else:
		return ''

func move_controller(index, mvt):
	# Hide previous position
	var coord = ctrlers_coord[index]
	ui_matrix[index][coord].is_empty = true
	# Show new position & memorize
	coord = (coord+mvt)%(nb_players+1)
	ctrlers_coord[index] = coord
	ui_matrix[index][coord].is_empty = false
