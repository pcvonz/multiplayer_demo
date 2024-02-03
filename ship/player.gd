extends Node2D
@export var player_name: String

@export var player_id := -1 :
	set(id):
		player_id = id
		# Give authority over the player input to the appropriate peer.
		$id.text = "%s" % player_name
		$PlayerInput.set_multiplayer_authority(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera = find_child("Camera2D")
	var input = $PlayerInput
	var ship = get_node("ship")
	ship.input = input
	if player_id == multiplayer.get_unique_id() and camera:
		camera.enabled = true
	elif camera:
		camera.enabled = false
