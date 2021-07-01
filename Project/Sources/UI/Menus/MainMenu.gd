extends Control

var CharSelectMenu = preload("res://Sources/UI/CharacterSelection/CharSelect_Menu.tscn")

# Memorization of the popup menu use to configurate the local game
onready var localPopup = $PopupLocal
onready var nbPlayerTxt = $PopupLocal/VBoxContainer/LineEdit
onready var nbplayerSlider = $PopupLocal/VBoxContainer/HSlider

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
		nbPlayerTxt.text = new_text
		nbplayerSlider.value = float(new_text)
	else:
		nbPlayerTxt.text = "2"
		nbplayerSlider.value = 2.0



func _on_HSlider_value_changed(value):
	nbPlayerTxt.text = String(value)
