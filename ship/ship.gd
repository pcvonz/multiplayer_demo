extends RigidBody2D

@export var speed: float = 10.0
@export var max_speed: float = 100.0
@export var angular_speed = .1
@export var max_angular_speed = 10.0
@export var stopping_speed = 2.0
@export var ship_name: String
@onready var missile_scene = preload("res://ship/Missile/missile.tscn")

signal on_add_to_spawner(node: Node)

@export var player_id := 1 :
	set(id):
		player_id = id
		# Give authority over the player input to the appropriate peer.
		$id.text = "%s" % ship_name
		$PlayerInput.set_multiplayer_authority(id)

@onready var input = $PlayerInput

func _ready():
	if player_id == multiplayer.get_unique_id():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false

func _process(_delta):
	if input.primary_weapon:
		input.primary_weapon = false
		var missile = missile_scene.instantiate()
		missile.add_collision_exception_with(self)
		missile.rotation = self.rotation
		missile.global_position = self.global_position
		missile.linear_velocity = self.linear_velocity
		
		on_add_to_spawner.emit(missile)

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if input.thrust_engaged:
		var speed_to_add= (Vector2(0, clampf(speed, 0, speed)).rotated(self.rotation))
		state.linear_velocity -= speed_to_add
	if input.rotating_port:
		state.angular_velocity = clampf(state.angular_velocity - angular_speed, -max_angular_speed, max_angular_speed)
	if input.rotating_starboard:
		state.angular_velocity = clampf(state.angular_velocity + angular_speed, -max_angular_speed, max_angular_speed)
	if input.rotating_port:
		state.linear_velocity -= (state.linear_velocity.normalized() * stopping_speed)
