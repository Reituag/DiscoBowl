extends VBoxContainer

# Scenes Import
var playerSelect = preload("res://Sources/UI/ControllerSelection/PlayerSelector.tscn")
var ctrl_indic = preload("res://Sources/UI/ControllerSelection/ControllerIndicator.tscn")

# VBox of the controller list
onready var ctrler_list : VBoxContainer = $CtrlerMatrix/Controllers/VBoxContainer/List
# HBox containing player selectors
onready var players : HBoxContainer = $CtrlerMatrix/Players
# Cancel button
onready var cancelButton = $Buttons/VBoxContainer/Cancel
# Cancel Progress
onready var cancelProgress = $Buttons/VBoxContainer/CancelProgress

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

# Each player column has a VBox in order to receive the controller indicators
# These Vboxes are listed in this variable
var player_lists = []
# Number of connected keyboards
export var nb_kboards = 1

var isCancelling = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	var nb_ctrlers = Input.get_connected_joypads().size()
	
	# Menu configuration given the number of players
	for i in Global.nb_players:
		# Addition of a character_selection widget
		var player_select = playerSelect.instance()
		player_select.player_name = "Player {n}".format({'n':i+1})
		players.add_child(player_select)
		# Memorization of its controller list
		player_lists.append(player_select)
	
	# Keyboards addition
	for i in range(nb_kboards):
		config_ctrler(true, i)
	
	# Joypads additions
	for i in range(nb_kboards, nb_ctrlers+nb_kboards):
		config_ctrler(false, i)
	
	Input.connect("joy_connection_changed", self, '_on_joy_connection_changed')
	cancelButton.connect("pressed", self, '_on_Cancel_pressed')
	cancelProgress.value = 0

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
	for j in Global.nb_players:
		create_ctrl_indic(index, is_keyboard, true, player_lists[j].get_list())

# Function allowing to create a controller indicator, configurate it and add it
# as a child of a given node.
# Used to instanciate every controller indicator at creating this menu.
func create_ctrl_indic(index, is_keyboard, is_empty, parentNode):
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

func _process(_delta):
	if isCancelling:
		cancelProgress.value += 1
		if cancelProgress.value == cancelProgress.max_value:
			_on_Cancel_pressed()

func _on_Cancel_pressed():
	get_tree().change_scene_to(Global.mainMenu)

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
		isCancelling = true
	elif event.is_action_released("ui_cancel"):
		cancelProgress.value = 0;
		isCancelling = false

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
		coord['col'] = (coord['col']+mvt)%(Global.nb_players+1)
		ctrlers_coord[index] = coord
		ui_matrix[index][coord['col']].is_empty = false

func lock_controller(index, is_locked):
	ctrlers_coord[index]['locked'] = is_locked
#	if ctrlers_coord[index]['col'] != 0:
	ui_matrix[index][ctrlers_coord[index]['col']].is_locked = is_locked
