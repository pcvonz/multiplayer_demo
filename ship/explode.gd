extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	explode()

func get_rigid_body(node: Node):
	if node is RigidBody2D:
		return node as RigidBody2D

func explode():
	var children = get_children().filter(get_rigid_body)
	
	for child in children:
		var x = randf_range(-100.0, 100.0)
		var y = randf_range(-100.0, 100.0)
		child.apply_impulse(Vector2(x, y))
