extends Node2D

onready var hit_effect = preload("res://scenes/HitEffect.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func spawn_particles(pos, effect):
	effect.set_position(pos)
	add_child(effect)
	

func _on_weapon_fired(recoil_vector, damage, hit_position, effect):
	print("weapon fired")
	spawn_particles(hit_position, effect)
	$ShakeCamera2D.add_trauma(0.3)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Gun.connect("weapon_fired", self, "_on_weapon_fired")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
