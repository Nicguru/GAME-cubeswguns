extends Node2D

export var path: NodePath
onready var player = get_node(path)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func midpoint(v1, v2):
	#print(v1, v2)
	var mp = (v1 + v2) / 2
	print(mp)
	return mp
	

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.set_global_position(midpoint(player.get_global_position(), get_global_mouse_position()))
