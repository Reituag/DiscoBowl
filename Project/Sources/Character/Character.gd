extends KinematicBody2D

const speed = 400  # How fast the character will move (pixels/sec).

export (PackedScene) var Disk
export (PackedScene) var Shield
var myDisk   = null
var myShield = null
var has_disk = true

var remaining_speed = Vector2.ZERO
export var damping_factor = 0.9

export var start_life = 100
var current_life

# Movement controller dedicated to this character's movement
var myController = preload("res://Sources/Character/JoypadCharacterController.tscn") \
					setget set_myController

signal die

func _ready():
	hide()
	$CatchArea.connect("body_entered", self, "_on_CatchArea_body_entered")
	$CatchArea.scale = Vector2(0.1, 0.1)
	current_life = start_life
	$LifeBar.max_value = start_life
	$LifeBar.value = current_life
	# Temporary controller configuration. This should be handled by a higher 
	# level instance as world or main
#	myController = myController.instance()
#	myController.config(0)

func set_myController(ctrl):
	myController = ctrl
	add_child(myController)

func start(pos):
	position = pos
	show()

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

func hit(hitting_body, _remainder, damage_amount):
	if hitting_body == myDisk:
		catch_disk(hitting_body)
	else:
		receive_damage(damage_amount)

func receive_damage(damage_amount):
	if current_life - damage_amount <= 0:
		emit_signal("die")
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
