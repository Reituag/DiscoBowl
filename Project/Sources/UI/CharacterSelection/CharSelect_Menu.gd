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
# { 'k0' : {'col' :0, 'locked' : true},
#   'j0' : {'col' :1, 'locked' : true},
#   'j1' : {'col' :2, 'locked' : false},
#   'j2' : {'col' :0, 'locked' : false} }
var ctrlers_coord = {}

# Number of Players.
# Defines the number of columns in addition of the controllers list
export var nb_players = 4
# Each player column has a VBox in order to receive the controller indicators
# These Vboxes are listed in this variable
var player_lists = []
# Number of connected keyboards
export var nb_kboards = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var nb_ctrlers = Input.get_connected_joypads().size()
	
	# Menu configuration given the number of players
	for i in nb_players:
		# Addition of a character_selection widget
		var charSelect = char_selec.instance()
		charSelect.character_name = "Player {n}".format({'n':i+1})
		$HBoxContainer.add_child(charSelect)
		# Memorization of its controller list
		player_lists.append(charSelect)
	
	# Keyboards addition
	for i in range(nb_kboards):
		config_ctrler(true, i)
	
	# Joypads additions
	for i in range(nb_kboards, nb_ctrlers+nb_kboards):
		config_ctrler(false, i)
	
	Input.connect("joy_connection_changed", self, '_on_joy_connection_changed')

# Fonction allowing to configurate entirely a controller given a device index
# and a status (keyboard or joypad)
func config_ctrler(is_keyboard, ctrler_index):
	# Index creation
	var index 
	if is_keyboard:
		index = 'k{n}'.format({'n':ctrler_index})
	else:
		index = 'j{0}'.format([ctrler_index])
	# First column : controller list
	create_ctrl_indic(index, is_keyboard, false, ctrler_list)
	# Addition in the coordinates memorization 
	ctrlers_coord[index] = {'col':0, 'locked':false}
	
	# Other columns, number of player dependant and hidden icons
	for j in nb_players:
		create_ctrl_indic(index, is_keyboard, true, player_lists[j].get_list())

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

func delete_ctrler(index):
	ctrlers_coord.erase(index)
	for elt in ui_matrix[index]:
		elt.queue_free()
	ui_matrix.erase(index)

func _on_joy_connection_changed(device: int, connected: bool):
	if connected:
		config_ctrler(false, device)
	else:
		delete_ctrler('j{0}'.format([device]))


func _input(event):
	if event.is_action_pressed("ui_right"):
		var index = get_device_index(event)
		if index != '':
			move_controller(index, +1)
	elif event.is_action_pressed("ui_left"):
		var index = get_device_index(event)
		if index != '':
			move_controller(index, -1)
	elif event.is_action_pressed("ui_accept"):
		var index = get_device_index(event)
		if index != '':
			lock_controller(index, true)
	elif event.is_action_pressed("ui_cancel"):
		var index = get_device_index(event)
		if index != '':
			lock_controller(index, false)

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
	if not coord['locked']:
		ui_matrix[index][coord['col']].is_empty = true
		# Show new position & memorize
		coord['col'] = (coord['col']+mvt)%(nb_players+1)
		ctrlers_coord[index] = coord
		ui_matrix[index][coord['col']].is_empty = false

func lock_controller(index, is_locked):
	ctrlers_coord[index]['locked'] = is_locked
#	if ctrlers_coord[index]['col'] != 0:
	ui_matrix[index][ctrlers_coord[index]['col']].is_locked = is_locked
