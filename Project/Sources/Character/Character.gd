extends KinematicBody2D

const speed = 400  # How fast the character will move (pixels/sec).

export (PackedScene) var Disk
var myDisk   = null
var has_disk = true

signal hit

func _ready():
	hide()
	$CatchArea.connect("body_entered", self, "_on_CatchArea_body_entered")
#	connect("body_entered",self, "_on_Character_body_entered")
#	$DiskTimer.connect("timeout", self, "_on_DiskTimer_timeout")

func _physics_process(delta):
	#######################
	# Movement management #
	#######################
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")
	
	move_and_slide(velocity)
	
	#######################
	# Throwing management #
	#######################
	
	# Get throw direction
	var throw_direction = get_viewport().get_mouse_position() - global_position
	var disk_pop_position = $Origin/DiskPop.global_position - global_position
	$Origin.rotate(disk_pop_position.angle_to(throw_direction))
	
	if Input.is_action_just_released("ui_attack") and has_disk:
		# Disk creation
		myDisk = Disk.instance()
		# Throw disk
		myDisk.throw($Origin/DiskPop.global_position, throw_direction)
		# Addition to scene
		get_parent().add_child(myDisk)
		
		# Disk possession management
		has_disk = false
		myDisk.connect("destroyed", self, "_on_disk_destroyed")

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

#func _on_Character_body_entered(_body):
#	emit_signal("hit")
#	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_disk_destroyed():
	has_disk = true
	myDisk = null
	$AudioStreamPlayer.play()

func _on_CatchArea_body_entered(body):
	if body == myDisk:
		var disk_to_me = myDisk.global_position - global_position
		# Dot product : if the disk is moving towards me, it is destroyed
		if disk_to_me.dot(myDisk.velocity) < 0:
			myDisk.destroy()
