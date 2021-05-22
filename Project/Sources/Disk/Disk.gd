extends KinematicBody2D
class_name Disk

# Disk movement speed, in pixels/sec
export var speed = 1200
# Maximal number of bounces before being destroyed
export var max_bounces = 4 

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
		
		if collision.collider.is_class("Disk"):
			# When 2 disks collide, they destroy each other
			collision.collider.destroy()
			destroy()
			
		elif current_bounces <= max_bounces:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit(collision.remainder)
		else:
			destroy()

func destroy():
	emit_signal("destroyed")
	queue_free()
