class_name Harvester extends RigidBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var mine_area: Area2D = $MineArea
@onready var progress_bar: ProgressBar = $ProgressBar

@export var player_id = -1
@export var team = -1
@export var resource_limit = 100
@export var currently_stored_resources = 0
@export var resource_chunk_size = 10
@export var home_position: Vector2
@export var current_mine: Node2D
var mining = true

func _ready():
	EventBus.on_mine_location_change.connect(_on_mine_location_change)
	progress_bar.max_value = resource_limit
	if multiplayer.is_server():
		# These values need to be adjusted for the actor's speed
		# and the navigation layout.
		navigation_agent.path_desired_distance = 4.0
		navigation_agent.target_desired_distance = 4.0

		# Make sure to not await during _ready.
		call_deferred("actor_setup")
	else:
		freeze = true

func _on_mine_location_change(node: Node2D, id: int):
	if id == player_id:
		current_mine = node
		set_movement_target(node.global_position)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func _process(_delta):
	progress_bar.value = (currently_stored_resources / resource_limit) * 100
	if mining == false:
		set_movement_target(home_position)
	else:
		if current_mine and is_instance_valid(current_mine):
			set_movement_target(current_mine.global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		linear_velocity = Vector2.ZERO
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	look_at(next_path_position)
	linear_velocity = current_agent_position.direction_to(next_path_position) * movement_speed

func _on_timer_timeout():
	if linear_velocity != Vector2.ZERO:
		return
	for body in mine_area.get_overlapping_bodies():
		if "mine_resource" in body:
			currently_stored_resources += body.mine_resource(resource_chunk_size)
			if currently_stored_resources >= resource_limit:
				mining = false
		if "store_resource" in body and currently_stored_resources > 0:
			if body.player_id == player_id:
				var resource_amount_to_store = minf(currently_stored_resources, resource_chunk_size)
				currently_stored_resources -= resource_amount_to_store
				body.store_resource(player_id, resource_amount_to_store)
				if currently_stored_resources <= 0:
					mining = true
