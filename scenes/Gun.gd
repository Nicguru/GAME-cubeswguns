extends Area2D

onready var hit_effect = preload("res://scenes/HitEffect.tscn")

const FIRE_RATE = 0.25
const KICKBACK = 500
const DAMAGE = 10
const AMMO_CAPACITY = 10

var reload_time = 3
var ammo = AMMO_CAPACITY

var can_fire = true
signal weapon_fired(recoil_vector, damage, hit_position, effect)

func spawn_particles(effect):
	effect.set_position(to_local($RayCast2D.get_collision_point()))
	add_child(effect)

func aim_self(point):
	rotation = point.angle()

func fire():
	if can_fire:
		can_fire = false
		ammo -= 1
		print("fire")
		print("ammo = ", ammo, "/", AMMO_CAPACITY)
		if ammo <= 0:
			$FireRateTimer.start(reload_time)
		else:
			$FireRateTimer.start(FIRE_RATE)
		
		emit_signal("weapon_fired", Vector2(-KICKBACK, 0).rotated(rotation),
		DAMAGE,
		$RayCast2D.get_collision_point(),
		hit_effect.instance())
		
		
		

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
		if ammo > 0:
			$FireRateTimer.stop()
			can_fire = true



func _on_FireRateTimer_timeout():
	can_fire = true
	if ammo <= 0:
		ammo = AMMO_CAPACITY
