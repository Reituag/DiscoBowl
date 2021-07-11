extends Node
class_name AutoController

var autoShoot = false
var autoShield = false
var is_shooting = false
var shield_action = "auto_shield"
var had_disk = false

func config(string):
	if "shoot" in string:
#		print("AutoShoot activated")
		autoShoot = true
		$Timer.wait_time = 0.2
		$Timer.autostart = false
		$Timer.one_shot = true
		$Timer.connect("timeout", self, '_on_timeout')
	elif "shield" in string:
#		print("AutoShield activated")
		autoShield = true
		$Timer.wait_time = 2.5
		$Timer.autostart = true
		$Timer.one_shot = false
		$Timer.connect("timeout", self, '_on_timeout')
	
	if not InputMap.has_action(shield_action):
		InputMap.add_action(shield_action)
		var shield_click = InputEventKey.new()
		shield_click.scancode = KEY_BACKSPACE
		InputMap.action_add_event(shield_action, shield_click)

func get_aim_direction() -> Vector2:
	if autoShoot:
#		print("autoshooting!")
#		print(String(had_disk) + " " + String(get_parent().has_disk) )
		if had_disk and not get_parent().has_disk:
			is_shooting = false
		elif not had_disk and get_parent().has_disk:
			$Timer.start()
		had_disk = get_parent().has_disk
	return Vector2.LEFT

func get_input() -> Vector2:
	return Vector2.ZERO

func _on_timeout():
	if autoShield:
		if Input.is_action_pressed(shield_action):
			Input.action_release(shield_action)
		else:
			Input.action_press(shield_action)
	elif autoShoot:
		is_shooting = true
