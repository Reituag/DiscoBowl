extends CenterContainer

export var is_keyboard = false setget set_keyboard
export var is_empty = false setget set_empty

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	draw()

func draw():
	$Keyboard.visible = is_keyboard and not is_empty
	$Gamepad.visible = not is_keyboard and not is_empty

func set_keyboard(status):
	is_keyboard = status
	draw()

func set_empty(status):
	is_empty = status
	draw()
