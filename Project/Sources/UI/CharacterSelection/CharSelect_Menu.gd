extends MarginContainer


var ctrl_indic = preload("res://Sources/UI/CharacterSelection/ControllerIndicator.tscn")
var ctrlers : Dictionary = {}
onready var ctrler_list : VBoxContainer = $HBoxContainer/Controllers/VBoxContainer/List

# Called when the node enters the scene tree for the first time.
func _ready():
	var keyboard_ctrler = ctrl_indic.instance()
	keyboard_ctrler.is_keyboard = true
	ctrlers['keyboards'] = {0:keyboard_ctrler}
	add_ctrler_indicator(keyboard_ctrler)
	
	for joy in Input.get_connected_joypads():
		var joypad_ctrler = ctrl_indic.instance()
		joypad_ctrler.is_keyboard = false
		ctrlers['joypads'] = {joy:joypad_ctrler}
		add_ctrler_indicator(joypad_ctrler)

func add_ctrler_indicator(elt):
	ctrler_list.add_child(elt)

func _input(event):
	if event.is_action_pressed("ui_right"):
		print(event.device)

