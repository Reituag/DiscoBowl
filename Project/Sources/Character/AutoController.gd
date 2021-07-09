extends Node
class_name AutoController

var autoShoot = false
var is_shooting = false
var shield_action = "auto_shield"

func config(string):
	if "shoot" in string:
		print("AutoShoot activated")
		autoShoot = true
	elif "shield" in string:
		print("AutoShield activated")
		$Timer.connect("timeout", self, '_on_timeout')
	InputMap.add_action(shield_action)
	var shield_click = InputEventKey.new()
	shield_click.scancode = KEY_BACKSPACE
	InputMap.action_add_event(shield_action, shield_click)

func get_aim_direction() -> Vector2:
	is_shooting = autoShoot
	return Vector2.LEFT

func get_input() -> Vector2:
	return Vector2.ZERO

func _on_timeout():
	print("HEY")
	if Input.is_action_pressed(shield_action):
		print('Shielding')
		Input.action_release(shield_action)
	else:
		print('unShielding')
		Input.action_press(shield_action)
