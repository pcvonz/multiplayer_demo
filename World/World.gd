extends Node2D
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var weapon_spawner: MultiplayerSpawner = get_node("WeaponSpawner")
var team = 0

func _ready():
	Global.player_id = multiplayer.get_unique_id()
	EventBus.on_add_to_spawner.connect(_on_add_to_spawner)
	spawner.spawn_function = spawn_player

	if not multiplayer.is_server():
		return

	for id in multiplayer.get_peers():
		spawner.spawn(id)
		team += 1

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		spawner.spawn(1)

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
					
func spawn_player(id: int):
	Global.players[id].team = team
	var new_player = preload("res://ship/player.tscn").instantiate()
	new_player.player_id = id
	new_player.name = "%s" % id
	new_player.global_position = get_node("team_%s" % team).global_position
	return new_player
