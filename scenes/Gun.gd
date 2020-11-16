extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const BULLET_SPEED = 400
const FIRE_RATE = 0.25
const KICKBACK = 150

var bullet = preload("res://scenes/Bullet.tscn")
var can_fire = true

func fire():
	if can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(BULLET_SPEED, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		$FireRateTimer.start(0.25)
		return Vector2(-KICKBACK, 0).rotated(rotation)
	else:
		return Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
#	$Sprite.flip_v = abs(fmod(rotation_degrees, 360)) > 90 and abs(fmod(rotation_degrees, 360)) < 270
	
	if Input.is_action_just_released("fire"):
		$FireRateTimer.stop()
		can_fire = true



func _on_FireRateTimer_timeout():
	can_fire = true
