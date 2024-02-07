class_name HarvestFactory extends Factory

var mine_location: Node2D
@export var player_id = -1

func _ready():
	super()
	EventBus.on_mine_location_change.connect(_on_mine_location_change)

func _on_mine_location_change(node: Node2D, id: int):
	if id == player_id:
		mine_location = node

func store_resource(player_id: int, amount: int):
	add_resources.rpc(player_id, amount)

@rpc("authority", "call_local")
func add_resources(id: int, value: int):
	var player = Global.players[id]
	player.energy += value
	player.resources += value

func spawn_scene():
	var scene: Harvester = currently_building.scene.instantiate()
	scene.team = team
	scene.position = get_new_spawn_pos()
	scene.player_id = player_id
	scene.home_position = $home_position.global_position
	var spawn_node = spawner.get_node(spawner.spawn_path)
	spawn_node.call_deferred("add_child", scene, true)

