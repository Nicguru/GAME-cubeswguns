extends KinematicBody2D

const ACCEL : int = 50
const MAX_SPEED = 300
const GRAVITY : int = 20

const ELASTICITY : int = 1200

#Jump
const MAX_JUMPS : int = 2
const JUMP_FORCE : int = 500
const JUMP_MIN : int = 200
var fallMultiplier : int = 2
var lowJumpMultiplier : int = 10
var jumps : int = MAX_JUMPS
var landed = false


#Wall Jumps
const WALL_SLIDE_ACCEL : int = 10
const MAX_WALL_SLIDE_SPEED : int = 120

var velocity : Vector2 = Vector2(0, 0)
var velocity_prev : Vector2 = Vector2()

var is_bullet_time = false


func _physics_process(delta):
	
	#inputs
	if Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + ACCEL, MAX_SPEED)
	elif Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - ACCEL, -MAX_SPEED)
	
	if is_on_floor():
		jumps = MAX_JUMPS
	else:
		landed = false
		$AnimatedSprite.scale.y = range_lerp(abs(velocity.y), 0, abs(JUMP_FORCE), 0.75, 1.75)
		$AnimatedSprite.scale.x = range_lerp(abs(velocity.y), 0, abs(JUMP_FORCE), 1.25, 0.75)


	
	#Jump
	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = -JUMP_FORCE
		
		#Wall Jumps
		if  is_on_wall() and Input.is_action_pressed("right"):
			velocity.x = -MAX_SPEED
		elif is_on_wall() and Input.is_action_pressed("left"):
			velocity.x = MAX_SPEED
		
		jumps -= 1
	
	
	#Shorten Jump based on length of key press
	if Input.is_action_just_released("jump") and velocity.y < -JUMP_MIN:
		velocity.y = -JUMP_MIN
	
	#Wall Slide
	if is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		jumps = MAX_JUMPS
		if velocity.y >= 0:
			velocity.y = min(velocity.y + WALL_SLIDE_ACCEL, MAX_WALL_SLIDE_SPEED)
	
	
	#gravity
	velocity.y += GRAVITY
	
	
	#handle movement
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#slow to a stop
	velocity.x = lerp(velocity.x, 0, 0.1)
	
	
	#fire gun
	if Input.is_action_pressed("fire") and $Gun.can_fire:
		var kickback_vel = $Gun.fire()
		if not is_on_floor():
			velocity.x = kickback_vel.x
			velocity.y = min(kickback_vel.y, velocity.y)
	
	
	#Squash and Stretch sprite based on movement
	if not landed and is_on_floor():
		landed = true
		$AnimatedSprite.scale.x = range_lerp(abs(velocity_prev.y), 0, abs(1700), 1.2, 2.0)
		$AnimatedSprite.scale.y = range_lerp(abs(velocity_prev.y), 0, abs(1700), 0.8, 0.5)
	
	$AnimatedSprite.scale.x = lerp($AnimatedSprite.scale.x, 1, 1 - pow(0.01, delta))
	$AnimatedSprite.scale.y = lerp($AnimatedSprite.scale.y, 1, 1 - pow(0.01, delta))
	
	
	#Face player to cursor using arctan
	var deg_to_pointer = rad2deg(atan2(get_local_mouse_position().x, get_local_mouse_position().y))
	
	$AnimatedSprite.flip_h = deg_to_pointer < 0
	
	$AnimatedSprite.set_frame(int(floor(abs(deg_to_pointer / 36))))
	
	if Input.is_action_just_pressed("ability_1"):
		is_bullet_time = !is_bullet_time
	
	if is_bullet_time:
		Engine.set_time_scale(0.25)
	else:
		Engine.set_time_scale(1)
	



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	




func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://scenes/Main.tscn")
