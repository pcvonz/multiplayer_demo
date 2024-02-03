extends Node2D
var spawner: MultiplayerSpawner
@onready var weapon_spawner: MultiplayerSpawner = get_node("WeaponSpawner")

func _ready():
	spawner = $MultiplayerSpawner
	spawner.spawn_function = spawn_ship
	if not multiplayer.is_server():
		return

	for id in multiplayer.get_peers():
		spawner.spawn(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		spawner.spawn(1)

func spawn(node: Node):
		var spawn_node = spawner.get_node(spawner.spawn_path)
		spawn_node.call_deferred("add_child", node)

func _on_add_to_spawner(node: Node):
		# Setup takes spawner and self as input
		if "setup" in node:
			node.setup(self, $WeaponSpawner)
		var weapon_spawn_node = weapon_spawner.get_node(weapon_spawner.spawn_path)
		weapon_spawn_node.call_deferred("add_child", node, true)
					
func spawn_ship(id: int):
	var new_ship = preload("res://ship/ship.tscn").instantiate()
	var player_name = Global.players[id].name
	new_ship.on_add_to_spawner.connect(_on_add_to_spawner)
	new_ship.ship_name = player_name
	new_ship.player_id = id
	new_ship.name = "%s" % id
	return new_ship
