extends RigidBody2D

const speed = 1000 # pixels/sec

var throw_direction = Vector2.UP
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func throw(direction):
#	show()
#	throw_direction = direction.normalized()
#	moving = true

func destroy():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if moving:
#		position += throw_direction * speed * delta
