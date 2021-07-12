extends AutoController
# This class allows to auto-define controls for a given joypad
class_name JoypadCharacterController

var myDevice = -1

var aim_dir = Vector2.UP
var aim_sensibility = 0.6

var aim_n
var shoot_n
var mv_up_n
var mv_down_n
var mv_left_n
var mv_right_n

# Actions and events configuration
func config(deviceIndex: int, _direction: Vector2 = Vector2.ZERO):
	myDevice = deviceIndex
	
	##########################
	# move up : axis & d-pad #
	##########################
	mv_up_n = "move_up_{n}".format({'n':myDevice})
	InputMap.add_action(mv_up_n)
	# Directionnal pad
	var mv_up_dpad = InputEventJoypadButton.new()
	mv_up_dpad.device = myDevice
	mv_up_dpad.button_index = JOY_DPAD_UP
	InputMap.action_add_event(mv_up_n, mv_up_dpad)
	# Analog stick
	var mv_up_axis = InputEventJoypadMotion.new()
	mv_up_axis.device = myDevice
	mv_up_axis.axis = JOY_AXIS_1
	mv_up_axis.axis_value = -0.5
	InputMap.action_add_event(mv_up_n, mv_up_axis)
	
	############################
	# move down : axis & d-pad #
	############################
	mv_down_n = "move_down_{n}".format({'n':myDevice})
	InputMap.add_action(mv_down_n)
	# Directionnal pad
	var mv_down_dpad = InputEventJoypadButton.new()
	mv_down_dpad.device = myDevice
	mv_down_dpad.button_index = JOY_DPAD_DOWN
	InputMap.action_add_event(mv_down_n, mv_down_dpad)
	# Analog stick
	var mv_down_axis = InputEventJoypadMotion.new()
	mv_down_axis.device = myDevice
	mv_down_axis.axis = JOY_AXIS_1
	mv_down_axis.axis_value = 0.5
	InputMap.action_add_event(mv_down_n, mv_down_axis)
	
	############################
	# move left : axis & d-pad #
	############################
	mv_left_n = "move_left_{n}".format({'n':myDevice})
	InputMap.add_action(mv_left_n)
	# Directionnal pad
	var mv_left_dpad = InputEventJoypadButton.new()
	mv_left_dpad.device = myDevice
	mv_left_dpad.button_index = JOY_DPAD_LEFT
	InputMap.action_add_event(mv_left_n, mv_left_dpad)
	# Analog stick
	var mv_left_axis = InputEventJoypadMotion.new()
	mv_left_axis.device = myDevice
	mv_left_axis.axis = JOY_AXIS_0
	mv_left_axis.axis_value = -0.5
	InputMap.action_add_event(mv_left_n, mv_left_axis)

	#############################
	# move right : axis & d-pad #
	#############################
	mv_right_n = "move_right_{n}".format({'n':myDevice})
	InputMap.add_action(mv_right_n)
	# Directionnal pad
	var mv_right_dpad = InputEventJoypadButton.new()
	mv_right_dpad.device = myDevice
	mv_right_dpad.button_index = JOY_DPAD_RIGHT
	InputMap.action_add_event(mv_right_n, mv_right_dpad)
	# Analog stick
	var mv_right_axis = InputEventJoypadMotion.new()
	mv_right_axis.device = myDevice
	mv_right_axis.axis = JOY_AXIS_0
	mv_right_axis.axis_value = 0.5
	InputMap.action_add_event(mv_right_n, mv_right_axis)
	
	#########################
	# Shoot : Right trigger #
	#########################
	shoot_n = "shoot_{n}".format({'n':myDevice})
	InputMap.add_action(shoot_n)
	var shoot_bt = InputEventJoypadButton.new()
	shoot_bt.device = myDevice
	shoot_bt.button_index = JOY_BUTTON_7
	InputMap.action_add_event(shoot_n, shoot_bt)
	
	#########################
	# Shield : Left trigger #
	#########################
	shield_action = "shield_{n}".format({'n':myDevice})
	InputMap.add_action(shield_action)
	var shield_bt = InputEventJoypadButton.new()
	shield_bt.device = myDevice
	shield_bt.button_index = JOY_BUTTON_6
	InputMap.action_add_event(shield_action, shield_bt)
	

# Actions handling. This function should be called in _physic_process in the
#  controlled character
# Returns a normalized vector
func get_input() -> Vector2:
	var velocity = Vector2()
	if Input.is_action_pressed(mv_right_n):
		velocity.x += 1
	if Input.is_action_pressed(mv_left_n):
		velocity.x -= 1
	if Input.is_action_pressed(mv_down_n):
		velocity.y += 1
	if Input.is_action_pressed(mv_up_n):
		velocity.y -= 1
	return velocity.normalized()


func get_aim_direction() -> Vector2:
	if abs(Input.get_joy_axis(myDevice, JOY_AXIS_2)) > aim_sensibility \
		or abs(Input.get_joy_axis(myDevice, JOY_AXIS_3)) > aim_sensibility:
		aim_dir.x = Input.get_joy_axis(myDevice, JOY_AXIS_2)
		aim_dir.y = Input.get_joy_axis(myDevice, JOY_AXIS_3)
		aim_dir.normalized()
	
	is_shooting = Input.is_action_pressed(shoot_n)
	return aim_dir
