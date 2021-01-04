extends Node2D

onready var hit_effect = preload("res://scenes/HitEffect.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func spawn_particles(pos):
	var effect = hit_effect.instance()
	effect.set_position(pos)
	add_child(effect)
	

func _on_weapon_fired(recoil_vector, damage, hit_position):
	print("weapon fired")
	spawn_particles(hit_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Gun.connect("weapon_fired", self, "_on_weapon_fired")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
