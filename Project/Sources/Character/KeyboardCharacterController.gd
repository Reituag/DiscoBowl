extends Node
# This class allows to auto-define character controls with the keyboard and mouse
class_name KeyboardCharacterController

var is_shooting = false

# Actions handling. This function should be called in _physic_process in the
#  controlled character
# Returns a normalized vector
func get_input() -> Vector2:
	var velocity = Vector2()
	if Input.is_action_pressed("move_right_kb"):
		velocity.x += 1
	if Input.is_action_pressed("move_left_kb" ):
		velocity.x -= 1
	if Input.is_action_pressed("move_down_kb" ):
		velocity.y += 1
	if Input.is_action_pressed("move_up_kb"   ):
		velocity.y -= 1
	return velocity.normalized()

func get_aim_direction() -> Vector2:
	var dir = get_viewport().get_mouse_position() - get_parent().global_position
	is_shooting = Input.is_action_pressed("shoot_kb")
	return dir.normalized()

# Actions and events configuration
func config(kb_type = 'azerty'):
	var keymap = {	'arrows'	: [KEY_UP, KEY_LEFT, KEY_DOWN, KEY_RIGHT],
					'azerty'	: [KEY_Z , KEY_Q   , KEY_S   , KEY_D    ],
					'qwerty'	: [KEY_W , KEY_A   , KEY_S   , KEY_D    ]}
	
	##############################
	# move up : arrows & letters #
	##############################
	InputMap.add_action("move_up_kb")
	# arrows
	var mv_up_arrow = InputEventKey.new()
	mv_up_arrow.scancode = keymap['arrows'][0]
	InputMap.action_add_event("move_up_kb", mv_up_arrow)
	# letters
	var mv_up_letter = InputEventKey.new()
	mv_up_letter.scancode = keymap[kb_type][0]
	InputMap.action_add_event("move_up_kb", mv_up_letter)
	
	################################
	# move left : arrows & letters #
	################################
	InputMap.add_action("move_left_kb")
	# arrows
	var mv_left_arrow = InputEventKey.new()
	mv_left_arrow.scancode = keymap['arrows'][1]
	InputMap.action_add_event("move_left_kb", mv_left_arrow)
	# letters
	var mv_left_letter = InputEventKey.new()
	mv_left_letter.scancode = keymap[kb_type][1]
	InputMap.action_add_event("move_left_kb", mv_left_letter)
	
	################################
	# move down : arrows & letters #
	################################
	InputMap.add_action("move_down_kb")
	# arrows
	var mv_down_arrow = InputEventKey.new()
	mv_down_arrow.scancode = keymap['arrows'][2]
	InputMap.action_add_event("move_down_kb", mv_down_arrow)
	# letters
	var mv_down_letter = InputEventKey.new()
	mv_down_letter.scancode = keymap[kb_type][2]
	InputMap.action_add_event("move_down_kb", mv_down_letter)
	
	#################################
	# move right : arrows & letters #
	#################################
	InputMap.add_action("move_right_kb")
	# arrows
	var mv_right_arrow = InputEventKey.new()
	mv_right_arrow.scancode = keymap['arrows'][3]
	InputMap.action_add_event("move_right_kb", mv_right_arrow)
	# letters
	var mv_right_letter = InputEventKey.new()
	mv_right_letter.scancode = keymap[kb_type][3]
	InputMap.action_add_event("move_right_kb", mv_right_letter)
	
	##############################
	# Shoot : space & left-click #
	##############################
	InputMap.add_action("shoot_kb")
	# space
	var shoot_space = InputEventKey.new()
	shoot_space.scancode = KEY_SPACE
	InputMap.action_add_event("shoot_kb", shoot_space)
	# Left-click
	var shoot_click = InputEventMouseButton.new()
	shoot_click.button_index = BUTTON_LEFT
	InputMap.action_add_event("shoot_kb", shoot_click)
