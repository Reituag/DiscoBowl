extends KinematicBody2D

const speed = 400  # How fast the character will move (pixels/sec).

export (PackedScene) var Disk
export (PackedScene) var Shield
var myDisk   = null
var myShield = null
var has_disk = true

var remaining_speed = Vector2.ZERO
export var damping_factor = 0.9

signal hit

func _ready():
	hide()
	$CatchArea.connect("body_entered", self, "_on_CatchArea_body_entered")
	$CatchArea.scale = Vector2(0.1, 0.1)

func start(pos):
	position = pos
	show()

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
	
	#Addition of velocity remaing from a hit
	if not remaining_speed.is_equal_approx(Vector2.ZERO) :
		velocity += remaining_speed*speed
		remaining_speed = remaining_speed*damping_factor
#		print(delta)
		
	move_and_slide(velocity)
	
	#######################
	# Throwing management #
	#######################
	
	# Get aiming direction
	var aim_direction = get_viewport().get_mouse_position() - global_position
	var disk_pop_position = $OriginDiskPop/DiskPop.global_position - global_position
	$OriginDiskPop.rotate(disk_pop_position.angle_to(aim_direction))
	
	if Input.is_action_just_released("ui_attack") and has_disk:
		# Disk creation
		myDisk = Disk.instance()
		# Throw disk
		myDisk.throw($OriginDiskPop/DiskPop.global_position, aim_direction)
		# Addition to scene
		get_parent().add_child(myDisk)
		
		# Disk possession management
		has_disk = false
		myDisk.connect("destroyed", self, "_on_disk_destroyed")
		$CatchArea.scale = Vector2(1,1)
		
	elif Input.is_action_just_pressed("ui_shield"):# and has_disk:
		myShield = Shield.instance()
		myShield.owner_character = self
		$OriginDiskPop/DiskPop.add_child(myShield)
		
	elif Input.is_action_just_released("ui_shield"):# and has_disk:
		myShield.queue_free()

func hit(remainder):
	print("OUCH")

func _on_disk_destroyed():
	has_disk = true
	myDisk = null
	$AudioStreamPlayer.play()

# Handle disk catching
func _on_CatchArea_body_entered(body):
	if body == myDisk:
		var disk_to_me = myDisk.global_position - global_position
		# Dot product : if the disk is moving towards me, it is destroyed
		if disk_to_me.dot(myDisk.velocity) < 0:
			myDisk.destroy()
			$CatchArea.scale = Vector2(0.1, 0.1)
