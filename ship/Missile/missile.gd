extends RigidBody2D

@export var speed = 1000.0
@export var max_speed = 1000.0
@export var damage: float = 10.0
@export var max_distance = 500.0
@onready var particle: CPUParticles2D = $particle
@export var homing := false
@export var team := -1
@export var rotation_speed = 2
var get_closest_node_in_group = preload("res://util/get_closest_node_in_group.gd")

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

func get_direction():
	var closest_player: Node2D = get_closest_node_in_group.run("ships", team, self, max_distance)
	if closest_player:
		return closest_player.global_position

func _process(_delta):
	if starting_position.distance_to(global_position) > max_distance:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D):
	if multiplayer.is_server():
		var direction = self.rotation
		if homing:
			var closest_pos = get_direction()
			if closest_pos:
				state.angular_velocity = -self.global_position.angle_to(closest_pos)*rotation_speed
		state.apply_force(Vector2(0, -speed).rotated(direction))
		state.linear_velocity = Vector2(clampf(state.linear_velocity.x, -max_speed, max_speed), clampf(state.linear_velocity.y, -max_speed, max_speed))

func _on_body_entered(body: Node):
	if "damage" in body and body.damage is Callable:
		body.damage(damage)
		queue_free()

