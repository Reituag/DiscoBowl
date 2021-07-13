extends Control

var CharSelectMenu = \
	preload("res://Sources/UI/ControllerSelection/CtrlerSelect_Menu.tscn")

# Memorization of children 
onready var localPopup = $PopupLocal
onready var nbLocalPlayerTxt = $PopupLocal/VBoxContainer/LocalNbPlayers
onready var nbLocalPlayerSlider = $PopupLocal/VBoxContainer/LocalSlider

onready var onlinePopup = $PopupOnline

var ok_str = ""

## Scene configuration ##
func _ready():
	localPopup.popup_exclusive = true
	nbLocalPlayerSlider.max_value = Global.max_local_players
	nbLocalPlayerSlider.tick_count = Global.max_local_players
	for i in range(1,Global.max_local_players+1):
		ok_str += String(i) + "_"

## Specific methods ##
func _create_local_game():
	# Number of player configuration
	Global.nb_players = int(nbLocalPlayerTxt.text)
	# Change node to new menu
	get_tree().change_scene_to(CharSelectMenu)

## Event handling ##
func _on_ButtonLocal_pressed():
	localPopup.popup()

func _on_ButtonCancel_pressed():
	localPopup.hide()

func _on_LineEdit_text_changed(new_text):
	# Ensures that the number of players is an integer in the correct range
	if (new_text in ok_str):
		nbLocalPlayerTxt.text = new_text
		nbLocalPlayerSlider.value = float(new_text)
	else:
		nbLocalPlayerTxt.text = "2"
		nbLocalPlayerSlider.value = 2.0

func _on_HSlider_value_changed(value):
	nbLocalPlayerTxt.text = String(value)

func _on_LocalStart_pressed():
	_create_local_game()


func _on_ButtonOnline_pressed():
	onlinePopup.popup()
