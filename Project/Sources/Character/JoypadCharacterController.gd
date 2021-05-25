extends Node
# This class allows to auto-define controls for a given joypad
class_name JoypadCharacterController

var myDevice = -1

# Actions and events configuration
func config(deviceIndex: int):
	myDevice = deviceIndex
	
	##########################
	# move up : axis & d-pad #
	##########################
	InputMap.add_action("move_up_{n}".format({'n':myDevice}))
	# Directionnal pad
	var mv_up_dpad = InputEventJoypadButton.new()
	mv_up_dpad.device = myDevice
	mv_up_dpad.button_index = JOY_DPAD_UP
	InputMap.action_add_event("move_up_{n}".format({'n':myDevice}), mv_up_dpad)
	# Analog stick
	var mv_up_axis = InputEventJoypadMotion.new()
	mv_up_axis.device = myDevice
	mv_up_axis.axis = JOY_AXIS_1
	mv_up_axis.axis_value = -0.5
	InputMap.action_add_event("move_up_{n}".format({'n':myDevice}), mv_up_axis)
	
	############################
	# move down : axis & d-pad #
	############################
	InputMap.add_action("move_down_{n}".format({'n':myDevice}))
	# Directionnal pad
	var mv_down_dpad = InputEventJoypadButton.new()
	mv_down_dpad.device = myDevice
	mv_down_dpad.button_index = JOY_DPAD_DOWN
	InputMap.action_add_event("move_down_{n}".format({'n':myDevice}), mv_down_dpad)
	# Analog stick
	var mv_down_axis = InputEventJoypadMotion.new()
	mv_down_axis.device = myDevice
	mv_down_axis.axis = JOY_AXIS_1
	mv_down_axis.axis_value = 0.5
	InputMap.action_add_event("move_down_{n}".format({'n':myDevice}), mv_down_axis)
	
	############################
	# move left : axis & d-pad #
	############################
	InputMap.add_action("move_left_{n}".format({'n':myDevice}))
	# Directionnal pad
	var mv_left_dpad = InputEventJoypadButton.new()
	mv_left_dpad.device = myDevice
	mv_left_dpad.button_index = JOY_DPAD_LEFT
	InputMap.action_add_event("move_left_{n}".format({'n':myDevice}), mv_left_dpad)
	# Analog stick
	var mv_left_axis = InputEventJoypadMotion.new()
	mv_left_axis.device = myDevice
	mv_left_axis.axis = JOY_AXIS_0
	mv_left_axis.axis_value = -0.5
	InputMap.action_add_event("move_left_{n}".format({'n':myDevice}), mv_left_axis)

	#############################
	# move right : axis & d-pad #
	#############################
	InputMap.add_action("move_right_{n}".format({'n':myDevice}))
	# Directionnal pad
	var mv_right_dpad = InputEventJoypadButton.new()
	mv_right_dpad.device = myDevice
	mv_right_dpad.button_index = JOY_DPAD_RIGHT
	InputMap.action_add_event("move_right_{n}".format({'n':myDevice}), mv_right_dpad)
	# Analog stick
	var mv_right_axis = InputEventJoypadMotion.new()
	mv_right_axis.device = myDevice
	mv_right_axis.axis = JOY_AXIS_0
	mv_right_axis.axis_value = 0.5
	InputMap.action_add_event("move_right_{n}".format({'n':myDevice}), mv_right_axis)

# Actions handling. This function should be called in _physic_process in the
#  controlled character
# Returns a normalized vector
func get_input() -> Vector2:
	var velocity = Vector2()
	if Input.is_action_pressed("move_right_{n}".format({'n':myDevice})):
		velocity.x += 1
	if Input.is_action_pressed("move_left_{n}".format({'n':myDevice}) ):
		velocity.x -= 1
	if Input.is_action_pressed("move_down_{n}".format({'n':myDevice}) ):
		velocity.y += 1
	if Input.is_action_pressed("move_up_{n}".format({'n':myDevice})   ):
		velocity.y -= 1
	return velocity.normalized()
