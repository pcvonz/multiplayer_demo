extends RigidBody2D

var speed = 1000.0
@export var damage: float = 10.0

func _ready():
	if not multiplayer.is_server():
		$Sprite2D.modulate = Color(1, 0, 0)
		$CollisionShape2D.disabled = true
		# Hack to stop jittery movement from physics
		freeze = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if multiplayer.is_server():
		state.apply_force(Vector2(0, -speed).rotated(self.rotation))

func _on_body_entered(body:Node):
	if "damage" in body and body.damage is Callable:
		body.damage(damage)
