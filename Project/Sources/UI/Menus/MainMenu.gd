extends Control

var CharSelectMenu = preload("res://Sources/UI/ControllerSelection/CtrlerSelect_Menu.tscn")

# Memorization of children 
onready var localPopup = $PopupLocal
onready var nbLocalPlayerTxt = $PopupLocal/VBoxContainer/LocalNbPlayers
onready var nbLocalPlayerSlider = $PopupLocal/VBoxContainer/LocalSlider

## Scene configuration ##
func _ready():
	localPopup.popup_exclusive = true

## Specific methods ##
func _create_local_game():
	pass

## Event handling ##
func _on_ButtonLocal_pressed():
	localPopup.popup()

func _on_ButtonCancel_pressed():
	localPopup.hide()

func _on_LineEdit_text_changed(new_text):
	var ok_str = "1_2_3_4_5_6_7_8"
	# Ensures that the number of players is an integer in [1;8]
	if (new_text in ok_str):
		nbLocalPlayerTxt.text = new_text
		nbLocalPlayerSlider.value = float(new_text)
	else:
		nbLocalPlayerTxt.text = "2"
		nbLocalPlayerSlider.value = 2.0

func _on_HSlider_value_changed(value):
	nbLocalPlayerTxt.text = String(value)

func _on_LocalStart_pressed():
	# Number of player configuration
	Global.nb_players = int(nbLocalPlayerTxt.text)
	# Change node to new menu
	get_tree().change_scene_to(CharSelectMenu)
