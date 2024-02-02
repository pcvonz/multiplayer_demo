extends RigidBody2D

var speed = 1000.0
@export var damage: float = 10.0

func _ready():
	if not multiplayer.is_server():
		$Sprite2D.modulate = Color(1, 0, 0)
		$CollisionShape2D.disabled = true
		sleeping = true
		set_physics_process_internal(false)
		set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if multiplayer.is_server():
		state.apply_force(Vector2(0, -speed).rotated(self.rotation))

func _on_body_entered(body:Node):
	if body.is_in_group("players"):
		body.damage(damage)

