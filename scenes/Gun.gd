extends Area2D

onready var hit_effect = preload("res://scenes/HitEffect.tscn")

const FIRE_RATE = 0
const KICKBACK = 500
const DAMAGE = 10

var can_fire = true
signal weapon_fired(recoil_vector, damage, hit_position)

func spawn_particles(effect):
	effect.set_position(to_local($RayCast2D.get_collision_point()))
	add_child(effect)

func aim_self(point):
	rotation = point.angle()

func fire():
	if can_fire:
		can_fire = false
		print("fire")
		print("....")
		$FireRateTimer.start(FIRE_RATE)

		emit_signal("weapon_fired", Vector2(-KICKBACK, 0).rotated(rotation),
		DAMAGE,
		$RayCast2D.get_collision_point())
	else:
		return Vector2.ZERO

func draw_laser():
	var end_point
	if ($RayCast2D.is_colliding()):
		end_point = to_local($RayCast2D.get_collision_point())
	else:
		end_point = $RayCast2D.get_cast_to()
	$RayCast2D/Line2D.points = [$BulletPoint.position, end_point]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	aim_self(get_global_mouse_position())
	look_at(get_global_mouse_position())
	draw_laser()
#	$Sprite.flip_v = abs(fmod(rotation_degrees, 360)) > 90 and abs(fmod(rotation_degrees, 360)) < 270
	
	if Input.is_action_pressed("fire") and can_fire:
		fire()
	
	if Input.is_action_just_released("fire"):
		$FireRateTimer.stop()
		can_fire = true



func _on_FireRateTimer_timeout():
	can_fire = true
