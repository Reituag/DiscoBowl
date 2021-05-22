extends KinematicBody2D

var owner_character = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit(_hitting_body, remainder : Vector2, _damages):
#	print("BLOCKED / remainder : {0}".format([remainder]))
	owner_character.remaining_speed = remainder.normalized()
