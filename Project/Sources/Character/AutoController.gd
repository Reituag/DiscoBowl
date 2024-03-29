extends Node
class_name AutoController

# Behaviour management variables
var _autoShoot = false
var _autoShield = false
var _timer : Timer

# Configurable aiming direction
var _aimDirection : Vector2

# Shooting status
var is_shooting = false

# Shielding action
var shield_action = "auto_shield"
var _hadDisk = false

func config(mode, direction : Vector2 = Vector2.LEFT):
	# timer instanciation
	_timer = Timer.new()
	add_child(_timer)
	if "shoot" in mode:
		# _autoShoot configuration:
		# Timer of 0.2s, started when the character has its disk
#		print("AutoShoot activated")
		_autoShoot = true
		_timer.wait_time = 0.2
		_timer.autostart = false
		_timer.one_shot = true
		# warning-ignore:return_value_discarded
		_timer.connect("timeout", self, '_on_timeout')
	
	# Addition of an action to manage shield. If various autoControllers
	# are added, the action is added only once. (avoids errors)
	# The action is always added, in order to be processed without error even if
	# only shooting is activated
	if not InputMap.has_action(shield_action):
#			print('Adding action ' + shield_action)
		# Action configuration
		InputMap.add_action(shield_action)
		var shield_click = InputEventKey.new()
		shield_click.scancode = KEY_BACKSPACE
		InputMap.action_add_event(shield_action, shield_click)
		
			# Auto Shield configuration:
			# Each 2.5s, shielding status is changed 
		if "shield" in mode:
	#		print("AutoShield activated")
			# Timer configuration
			_autoShield = true
			_timer.wait_time = 2.5
			_timer.autostart = true
			_timer.one_shot = false
			# warning-ignore:return_value_discarded
			_timer.connect("timeout", self, '_on_timeout')
		
	# Memorization of the aiming direction
	_aimDirection = direction

# Returns predefined aiming direction.
func get_aim_direction() -> Vector2:
	_compute_shooting()
	return _aimDirection

# Autoshooting management :
# If auto shooting is activated, 
# when catching the disk (had no disk + has now), shoot after timeout
# when throwing the disk (had disk + hasn't now), shooting is desactivated
func _compute_shooting():
	if _autoShoot:
#		print("autoshooting!")
#		print(String(_hadDisk) + " " + String(get_parent().has_disk) )
		if _hadDisk and not get_parent().has_disk:
			# Shooting desactivated when throwing the disk
			is_shooting = false
		elif not _hadDisk and get_parent().has_disk:
			# When catching the disk, timer is set, shoot at timeout
			_timer.start()
		# Memorization of previous status
		_hadDisk = get_parent().has_disk

# Immomible
func get_input() -> Vector2:
	return Vector2.ZERO

# Function called when timer ends.
# Shield management:
#	Change status, lower when raised, raise when lowered
# Shooting management:
#	Activate shooting
func _on_timeout():
	if _autoShield:
		if Input.is_action_pressed(shield_action):
#			print(String(OS.get_time())+": lowering shields ! vvvv")
			Input.action_release(shield_action)
		else:
#			print(String(OS.get_time())+": raising shields ! ^^^^")
			Input.action_press(shield_action)
	elif _autoShoot:
		is_shooting = true
