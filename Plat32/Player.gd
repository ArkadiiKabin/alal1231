extends KinematicBody2D


onready var _animated_sprite = $AnimatedSprite

export (int) var speed = 200
export (int) var jump_speed = -1100
export (int) var gravity = 4000

var velocity = Vector2.ZERO
var jumpo = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		_animated_sprite.flip_h=false
		if not jumpo:
			_animated_sprite.play("run")
		velocity.x += speed	
	elif Input.is_action_pressed("move_left"):
		_animated_sprite.flip_h=true
		if not jumpo:
			_animated_sprite.play("run")
		velocity.x -= speed
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			_animated_sprite.play("jump up")
			velocity.y = jump_speed
			jumpo=true
		
func _physics_process(delta):
	get_input()

	velocity.y += gravity * delta
	if(velocity.x==0 and not jumpo):
		_animated_sprite.play("idle")
	elif(velocity.y>0 and jumpo):
		_animated_sprite.play("jump down")
	velocity = move_and_slide(velocity, Vector2.UP)
	if jumpo == true and is_on_floor():
		jumpo=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
