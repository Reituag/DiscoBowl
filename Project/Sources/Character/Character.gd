extends KinematicBody2D

const speed = 400  # How fast the character will move (pixels/sec).
var screen_size  # Size of the game window.

var available_throw = true
var throw_direction : Vector2 = Vector2.RIGHT

export (PackedScene) var Disk
var myDisk = null

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	connect("body_entered",self, "_on_Character_body_entered")
	$DiskTimer.connect("timeout", self, "_on_DiskTimer_timeout")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2()  # The player's movement vector.
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
	
	if Input.is_action_just_released("ui_attack") and available_throw:
		# Get throw direction
		throw_direction = get_viewport().get_mouse_position() - global_position
		
		# Disk creation
		myDisk = Disk.instance()
		myDisk.global_position = global_position \
			+ throw_direction.normalized()*35.0
		get_parent().add_child(myDisk)
		
		# Disk throwing
#		myDisk.throw(throw_direction)
		print(throw_direction)
		myDisk.apply_central_impulse(throw_direction.normalized() * myDisk.speed)
		
		# timer management
		$DiskTimer.start()
		$DiskTimer.connect("timeout", myDisk, "destroy")
		available_throw = false

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Character_body_entered(_body):
#    hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_DiskTimer_timeout():
	available_throw = true
	$AudioStreamPlayer.play()
