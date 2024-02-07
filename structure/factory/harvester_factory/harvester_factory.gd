class_name HarvestFactory extends Factory

var mine_location: Node2D
@export var player_id = -1
signal on_mine_location_change(mine: Node2D)

func set_mine_location(node: Node2D):
	mine_location = node
	on_mine_location_change.emit(mine_location)

func spawn_scene():
	var scene: Harvester = currently_building.scene.instantiate()
	scene.team = team
	scene.position = get_new_spawn_pos()
	on_mine_location_change.connect(scene._on_mine_location_change)
	var spawn_node = spawner.get_node(spawner.spawn_path)
	spawn_node.call_deferred("add_child", scene, true)

