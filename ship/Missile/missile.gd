extends RigidBody2D

var speed = 1000.0
@export var damage: float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	state.apply_force(Vector2(0, -speed).rotated(self.rotation))

func _on_body_entered(body:Node):
	print(body)
	print(body.name)
	if body.is_in_group("players"):
		body.damage(damage)

