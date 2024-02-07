extends Node2D
@export var player_name: String
@onready var camera: Camera2D = $Camera2D
@onready var unit: Node
@onready var input: MultiplayerSynchronizer = $PlayerInput

const CAMERA_SPEED = 6.0
signal on_add_to_spawner(node: Node)

@export var player_id := -1 :
	set(id):
		player_id = id
		# Give authority over the player input to the appropriate peer.
		$id.text = "%s" % player_name
		$PlayerInput.set_multiplayer_authority(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_id == multiplayer.get_unique_id() and camera:
		camera.enabled = true
	elif camera:
		camera.enabled = false

func _process(delta):
	if unit and is_instance_valid(unit):
		camera.global_position = unit.global_position
	else:
		if !input:
			return
		if input.thrust_engaged:
			camera.global_position += ( Vector2(0, -1) ) * CAMERA_SPEED
		if input.rotating_port:
			camera.global_position += ( Vector2(-1, 0) ) * CAMERA_SPEED
		if input.rotating_starboard:
			camera.global_position += ( Vector2(1, 0) ) * CAMERA_SPEED
		if input.brake_engaged:
			camera.global_position += ( Vector2(0, 1) ) * CAMERA_SPEED

func _on_destroyed():
	unit = null

@rpc("call_local", "reliable", "any_peer")
func take_control(node: NodePath, player_id_requesting_control: int):
	for player in get_tree().get_nodes_in_group("players"):
		if  player.player_id == player_id_requesting_control:
			if player.unit and is_instance_valid(player.unit):
				player.unit.input = null
				if player.unit.on_destroyed.is_connected(_on_destroyed):
					player.unit.on_destroyed.disconnect(_on_destroyed)

			player.unit = get_node(node)
			player.unit.input = player.input

func _on_take_control(node: Node, player_id_requesting_control: int):
	take_control.rpc(node.get_path(), player_id_requesting_control)
	if unit and is_instance_valid(unit):
		unit.on_destroyed.connect(_on_destroyed)
