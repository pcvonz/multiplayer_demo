extends RigidBody2D

var speed = 1000.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	state.apply_force(Vector2(0, -speed).rotated(self.rotation))
