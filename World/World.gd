extends NavigationRegion2D
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var weapon_spawner: MultiplayerSpawner = get_node("WeaponSpawner")
var team = 0

func _ready():
	Global.player_id = multiplayer.get_unique_id()
	EventBus.on_add_to_spawner.connect(_on_add_to_spawner)
	EventBus.on_add_static_body.connect(_on_add_static_body)

	if not multiplayer.is_server():
		return

	Lobby.player_connected.connect(spawn_player)

func _on_add_static_body(_node: Node):
	bake_navigation_polygon()

func spawn(node: Node):
		var spawn_node = spawner.get_node(spawner.spawn_path)
		spawn_node.call_deferred("add_child", node)

func _on_add_to_spawner(node: Node):
		if !multiplayer.is_server():
			return
		if "setup" in node:
			node.setup(self, $WeaponSpawner)
		var weapon_spawn_node = weapon_spawner.get_node(weapon_spawner.spawn_path)
		weapon_spawn_node.add_child(node, true)

# TODO: Type player info
func spawn_player(id: Variant):
	Global.players[id].team = team
	var new_player: Player = preload("res://ship/player.tscn").instantiate()
	new_player.input.set_multiplayer_authority(id)
	new_player.player_id = id
	new_player.global_position = get_node("team_%s" % team).global_position
	# TODO: The take control function doesn't set the input for any user who isn't the server. Which makes it so other user's don't have control over their default ship
	$PlayerSpawner.add_child(new_player, true)
