extends Node2D
var spawner: MultiplayerSpawner
@onready var weapon_spawner: MultiplayerSpawner = get_node("WeaponSpawner")

func _ready():
	spawner = $MultiplayerSpawner
	spawner.spawn_function = spawn_ship
	Global.player_id = multiplayer.get_unique_id()

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
		if !multiplayer.is_server():
			return
		# Setup takes spawner and self as input
		if "setup" in node:
			node.setup(self, $WeaponSpawner)
		var weapon_spawn_node = weapon_spawner.get_node(weapon_spawner.spawn_path)
		weapon_spawn_node.add_child(node, true)
					
func spawn_ship(id: int):
	var new_player = preload("res://ship/player.tscn").instantiate()
	var new_ship = preload("res://ship/construction_ship/construction_ship.tscn").instantiate()
	var player_name = Global.players[id].name
	new_player.on_add_to_spawner.connect(_on_add_to_spawner)
	new_player.player_id = id
	new_player.name = "%s" % id
	new_player.unit = new_ship
	new_ship.input = new_player.input
	new_player.add_child(new_ship)
	return new_player
