extends Node2D

var starting_linear_velocity := Vector2(0, 0)

func _ready():
	explode()
	var children = get_children().filter(get_rigid_body)
	for child in children:
		child.freeze = true

func get_rigid_body(node: Node):
	if node is RigidBody2D:
		return node as RigidBody2D

func explode():
	var children = get_children().filter(get_rigid_body)
	
	for child in children:
		child.freeze = false
		var x = randf_range(-100.0, 100.0)
		var y = randf_range(-100.0, 100.0)
		child.linear_velocity = starting_linear_velocity
		child.apply_impulse(Vector2(x, y))
