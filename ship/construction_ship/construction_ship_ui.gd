extends Control

var factory: FactoryItem = ResourceLoader.load("res://ui/factory_items/factory.tres")
var energy_generator: FactoryItem = ResourceLoader.load("res://ui/factory_items/energy_generator.tres")
var turret: FactoryItem = ResourceLoader.load("res://ui/factory_items/turret.tres")
var harvester_factory: FactoryItem = ResourceLoader.load("res://ui/factory_items/harvester_factory.tres")

var placing = false
var to_place_func: Callable

func get_position_of_ship():
	return get_parent().get_parent().global_position

var resource_cost: int = 0

func _input(event):
	if placing and event.is_action_released("click"):
		var player = Global.get_player()
		if player.resources >= resource_cost:
			player.resources -= resource_cost
			var mouse_event: InputEventMouse = event
			var mouse_position = mouse_event.position
			var position_to_place = mouse_position - (get_viewport().get_visible_rect().size / 2)
			print("Position from input event: ", position_to_place + get_position_of_ship())
			to_place_func.rpc(position_to_place + get_position_of_ship(), Global.player_id)
			placing = false

func _on_build_factory_pressed():
	placing = true
	resource_cost = factory.cost
	to_place_func = build_factory

func _on_build_energy_pressed():
	placing = true
	resource_cost = energy_generator.cost
	to_place_func = build_energy_generator

func _on_build_turret_pressed():
	placing = true
	resource_cost = turret.cost
	to_place_func = build_turret

func _on_build_harvester_factory_pressed():
	placing = true
	resource_cost = turret.cost
	to_place_func = build_harvester_factory

@rpc("reliable", "any_peer", "call_local")
func build_factory(pos: Vector2, player_id: int):
	var factory_scene = factory.scene.instantiate()
	factory_scene.team = Global.players[player_id].team
	factory_scene.global_position = pos
	EventBus.on_add_to_spawner.emit(factory_scene)

@rpc("reliable", "any_peer", "call_local")
func build_harvester_factory(pos: Vector2, player_id: int):
	var harvester_factory_scene = harvester_factory.scene.instantiate()
	harvester_factory_scene.player_id = player_id
	harvester_factory_scene.team = Global.players[player_id].team
	harvester_factory_scene.global_position = pos
	EventBus.on_add_to_spawner.emit(harvester_factory_scene)

@rpc("reliable", "any_peer", "call_local")
func build_turret(pos: Vector2, player_id: int):
	if multiplayer.is_server():
		var turret_scene = turret.scene.instantiate()
		turret_scene.team = Global.players[player_id].team
		turret_scene.global_position = pos
		EventBus.on_add_to_spawner.emit(turret_scene)

@rpc("reliable", "any_peer", "call_local")
func build_energy_generator(pos: Vector2, player_id: int):
	if multiplayer.is_server():
		var generator = energy_generator.scene.instantiate()
		generator.team = Global.players[player_id].team
		generator.player_id = player_id
		generator.global_position = pos
		print("Position: ", pos)
		EventBus.on_add_to_spawner.emit(generator)

