extends KinematicBody2D
class_name Disk

# Disk movement speed, in pixels/sec
export var speed = 1200
# Maximal number of bounces before being destroyed
export var max_bounces = 4
# Default amount of damage for the disk
export var dmg_amount = 35

signal destroyed

var current_bounces = 0
var velocity = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called to throw the disk
# The disk will be created at the given position, and move in the given direction
func throw(pos, direction):
	rotation = direction.angle()
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	current_bounces = 0


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		current_bounces += 1
		
		if collision.collider.has_method("hit"):
			collision.collider.hit(self, collision.remainder, dmg_amount)
		
		# If bounces are remaining the disk bounces
		if current_bounces <= max_bounces:
			velocity = velocity.bounce(collision.normal) 
		# If no bounces are remaining, the disk is destroyed
		else:
			destroy()

func hit(hitting_body, _remainder, damage_amount):
	if hitting_body.is_class("Disk"):
		hitting_body.destroy()
		destroy()

func destroy():
	velocity = Vector2.ZERO
	emit_signal("destroyed")
	queue_free()
