extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -1100
export (int) var gravity = 4000

var velocity = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	if state != "podkat":
		velocity.x=0
	if state !="attack" and state !="combo start" and state !="combo end":
		if state != "podkat":
			if Input.is_action_pressed("move_right"):
				velocity.x=speed
				if state !="jump":
					state="run"
			elif Input.is_action_pressed("move_left"):
				velocity.x=-speed
				if state !="jump":
					state="run"
			if Input.is_action_just_pressed("jump"):
				if is_on_floor():
					velocity.y=jump_speed
					state="jump"
		if Input.is_action_just_pressed("podkat_e"):
			velocity.x=speed*2
			if state !="jump":
				state="podkat"
		if Input.is_action_just_pressed("podkat_q"):
			velocity.x=-speed*2
			if state !="jump":
				state="podkat"
	if Input.is_action_just_pressed("attack"):
		if state == "run" or state=="idle" or state == "attack":
			if state == "attack":
				state="combo start"
			else:
				state="attack"
			
			
func animation_state():
	if state == "idle":
		$AnimatedSprite.animation="idle"
	elif state == "run":
		if velocity.x > 0:
			$AnimatedSprite.flip_h=false
		else:
			$AnimatedSprite.flip_h=true
		$AnimatedSprite.animation="run"
	elif state == "podkat":
		if velocity.x > 0:
			$AnimatedSprite.flip_h=false
		else:
			$AnimatedSprite.flip_h=true
		$AnimatedSprite.animation="podkat"
		$CollisionShape2D.shape.height = 0
		$AnimatedSprite.position.y = -7
	elif state == "jump":
		if velocity.x > 0:
			$AnimatedSprite.flip_h=false
		else:
			$AnimatedSprite.flip_h=true
		if velocity.y>0:
			$AnimatedSprite.animation="jump down"
		elif velocity.y<0:
			$AnimatedSprite.animation="jump up"
	elif state == "attack":
		 $AnimatedSprite.animation="attack"
		
	
	

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if velocity.x==0 and is_on_floor() and (state == "run" or state == "jump") :
		state = "idle"
	if velocity.x!=0 and is_on_floor() and state == "jump" :
		state = "run"
	animation_state()
	print(state)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	if state =="attack":
		state="idle"
	elif state == "combo start":
		$AnimatedSprite.animation="combo"
		state = "combo end"
	elif state == "combo end":
		state="idle"
		$AnimatedSprite.animation="idle"
	elif state == "podkat":
		$CollisionShape2D.shape.height = 20
		$AnimatedSprite.position.y = -11
		state = "idle"
	
		
	pass # Replace with function body.
