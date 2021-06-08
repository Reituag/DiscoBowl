extends PanelContainer

export var character_name = 'PlayerX' setget set_name
onready var _name = $VBoxContainer/MarginContainer/Label
onready var list = $VBoxContainer/CtrlerList


# Called when the node enters the scene tree for the first time.
func _ready():
	_name.text = character_name

func get_list():
	return list

func set_name(mikky):
	character_name = mikky
	if _name is Node:
		_name.text = character_name
