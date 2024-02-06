extends RigidBody2D

@export var speed = 1000.0
@export var damage: float = 10.0
@export var max_distance = 500.0
@onready var particle: CPUParticles2D = $particle

var starting_position: Vector2

func _ready():
	particle.emitting = false
	starting_position = self.global_position
	particle.one_shot = true
	if not multiplayer.is_server():
		$Sprite2D.modulate = Color(1, 0, 0)
		$CollisionShape2D.disabled = true
		# Hack to stop jittery movement from physics
		freeze = true

func _process(_delta):
	if starting_position.distance_to(global_position) > max_distance:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if multiplayer.is_server():
		state.apply_force(Vector2(0, -speed).rotated(self.rotation))

func _on_body_entered(body: Node):
	if "damage" in body and body.damage is Callable:
		body.damage(damage)
		queue_free()

