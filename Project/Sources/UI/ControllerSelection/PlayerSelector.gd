extends PanelContainer

export var player_name = 'PlayerX' setget set_name
onready var _name = $VBoxContainer/Label
onready var list = $VBoxContainer/CtrlerList


# Called when the node enters the scene tree for the first time.
func _ready():
	_name.text = player_name

func get_list():
	return list

func set_name(mikky):
	player_name = mikky
	if _name is Node:
		_name.text = player_name
