class_name Harvester extends RigidBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var team = -1

func _ready():
	if multiplayer.is_server():
		# These values need to be adjusted for the actor's speed
		# and the navigation layout.
		navigation_agent.path_desired_distance = 4.0
		navigation_agent.target_desired_distance = 4.0

		# Make sure to not await during _ready.
		call_deferred("actor_setup")
	else:
		freeze = true

func _on_mine_location_change(node: Node2D):
	print(node)

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(node.global_position)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		linear_velocity = Vector2.ZERO
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	linear_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
