extends KinematicBody2D

# General behaviour configuration
export var speed = 400  # How fast the character will move (pixels/sec).
export var start_life = 100
var current_life

# Modular configuration of Disk and Shield
export (PackedScene) var Disk
export (PackedScene) var Shield
# Link with children
var myDisk   = null
var myShield = null
var has_disk = true

# On blocking a disk behaviour variables
var remaining_speed = Vector2.ZERO
var damping_factor = 0.9

# Movement controller dedicated to this character's movement
var myController = AutoController.new()

# Player name
var myName = "defaultName" setget set_name
onready var labelName = $NameContainer/myName

signal die



func _ready():
	hide()
	$CatchArea.connect("body_entered", self, "_on_CatchArea_body_entered")
	$CatchArea.scale = Vector2(0.1, 0.1)
	current_life = start_life
	$LifeBar.max_value = start_life
	$LifeBar.value = current_life
	
	$FallArea.connect("body_entered", self, "_on_FallArea_body_entered")

func start(pos, ctrler):
	# start position definition
	position = pos
	# Controller definition
	myController = ctrler
	add_child(myController)
	
	# If a keyboard controller is configured, the mouse cursor is hidden
	if myController is KeyboardCharacterController:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Display in scene
	show()

func set_name(new_name):
	myName = new_name
	labelName.text = new_name

func _physics_process(_delta):
	#######################
	# Movement management #
	#######################
	var velocity = myController.get_input()
	
	if velocity.length() > 0:
		velocity = velocity * speed
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")
	
	# Addition of velocity remaing from a hit
	if not remaining_speed.is_equal_approx(Vector2.ZERO) :
		velocity += remaining_speed*speed
		remaining_speed = remaining_speed*damping_factor
	
	move_and_slide(velocity)
	
	#######################
	# Throwing management #
	#######################
	
	# Get aiming direction
	var aim_direction = myController.get_aim_direction()
	var disk_pop_position = $OriginDiskPop/DiskPop.global_position - global_position
	var rotation_angle = disk_pop_position.angle_to(aim_direction)
	# Rotation limitation in ]-pi; +pi]
	if $OriginDiskPop.rotation + rotation_angle > PI:
#		print("oldval: {0}, newval: {1}".format(
#			[$OriginDiskPop.rotation + rotation_angle, 
#			$OriginDiskPop.rotation + rotation_angle -PI ]))
		rotation_angle -= 2*PI 
	elif $OriginDiskPop.rotation + rotation_angle < -PI:
		rotation_angle += 2*PI
	$OriginDiskPop.rotate(rotation_angle)
	
	if myController.is_shooting and has_disk and myShield == null:
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
		
	elif Input.is_action_just_pressed(myController.shield_action) and has_disk:
		myShield = Shield.instance()
		myShield.owner_character = self
		$OriginDiskPop/DiskPop.add_child(myShield)
		$OriginDiskPop/DiskPop/Reticule.hide()
		
	elif Input.is_action_just_released(myController.shield_action) and has_disk \
		and is_instance_valid(myShield):
		myShield.queue_free()
		$OriginDiskPop/DiskPop/Reticule.show()
		myShield = null
	
	#################
	# UI management #
	#################
#	if myController is JoypadCharacterController:
#		print(String($OriginDiskPop.rotation) + " / " + String($NameContainer.rect_position.y))
	if abs($OriginDiskPop.rotation_degrees) < 45 && $NameContainer.rect_position.y > 0:
#		print("Time: {1}# Angle: {0}".\
#			format([$OriginDiskPop.rotation_degrees,OS.get_time()]))
		$NameContainer.set_position(Vector2(0,-50))
	elif abs($OriginDiskPop.rotation_degrees) > 50 && $NameContainer.rect_position.y < 0:
#		print("Time: {1}# Angle: {0}".\
#			format([$OriginDiskPop.rotation_degrees,OS.get_time()]))
		$NameContainer.set_position(Vector2(0,50))
	elif abs($OriginDiskPop.rotation_degrees) > 360:
		print("WARNING: Aiming rotation on {name} over 360. Value: {val}"\
			.format({"name":myName, "val":$OriginDiskPop.rotation_degrees}))

###########################
## DISK HANDLING SECTION ##
###########################

# Function called by any hitting object (disk)
func hit(hitting_body, _remainder, damage_amount):
	if hitting_body == myDisk:
		catch_disk(hitting_body)
	else:
		receive_damage(damage_amount)
		hitting_body.destroy()

func receive_damage(damage_amount):
	if current_life - damage_amount <= 0:
		emit_signal("die")
		current_life = 0
	else:
		current_life -= damage_amount
	$LifeBar.value = current_life

func catch_disk(_disk):
	myDisk.destroy()
	$CatchArea.scale = Vector2(0.1, 0.1)

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
			catch_disk(body)


###############################
## PLATFORM HANDLING SECTION ##
###############################

func _on_FallArea_body_entered(_body):
	print(myName + " fell into the emptyness")
	emit_signal("die")
