extends Area2D

export var speed = 400  # How fast the character will move (pixels/sec).
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
func _process(delta):
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
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("ui_attack") and available_throw:
		throw_direction = get_viewport().get_mouse_position() - global_position
		myDisk = Disk.instance()
		myDisk.global_position = global_position
		get_parent().add_child(myDisk)
		myDisk.throw(throw_direction)
		$DiskTimer.start()
		$DiskTimer.connect("timeout", myDisk, "destroy")
		available_throw = false

func _input(event):
	if event is InputEventMouseMotion:
		get_parent().get_node("Sprite").position = get_viewport().get_mouse_position()

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
