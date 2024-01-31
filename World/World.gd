extends Node2D
var spawner: MultiplayerSpawner

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

func _on_add_to_spawner(node: Node):
		$WeaponSpawner.add_child(node)

func spawn_ship(id: int):
	var new_ship = preload("res://ship/ship.tscn").instantiate()
	var player_name = Global.players[id].name
	new_ship.on_add_to_spawner.connect(_on_add_to_spawner)
	new_ship.ship_name = player_name
	new_ship.player_id = id
	return new_ship

