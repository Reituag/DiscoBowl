extends KinematicBody2D

const speed = 1200 # pixels/sec
const max_bounces = 4

signal destroyed

var bounces = 0
var velocity = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func throw(pos, direction):
	rotation = direction.angle()
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	bounces  = 0


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		bounces += 1
		
		if bounces <= max_bounces:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit()
		else:
			emit_signal("destroyed")
			queue_free()
