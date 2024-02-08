extends Control

var build_preview: PackedScene = preload("res://build_preview/build_preview.tscn")

var placing = false
var to_place_func: Callable

func get_position_of_ship():
	return get_parent().get_parent().global_position

var resource_cost: float = 0

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
	to_place_func = build_factory

func _on_build_energy_pressed():
	placing = true
	to_place_func = build_energy_generator

func _on_build_turret_pressed():
	placing = true
	to_place_func = build_turret

func _on_build_harvester_factory_pressed():
	placing = true
	to_place_func = build_harvester_factory

func build(resource_path: String, pos: Vector2, player_id: int):
		var build_preview_scene: BuildPreview = build_preview.instantiate()
		build_preview_scene.resource_path = resource_path
		build_preview_scene.team = Global.players[player_id].team
		build_preview_scene.player_id = player_id
		build_preview_scene.global_position = pos
		EventBus.on_add_to_spawner.emit(build_preview_scene)
		

@rpc("reliable", "any_peer", "call_local")
func build_factory(pos: Vector2, player_id: int):
	build("res://ui/factory_items/factory.tres", pos, player_id)

@rpc("reliable", "any_peer", "call_local")
func build_harvester_factory(pos: Vector2, player_id: int):
	build("res://ui/factory_items/harvester_factory.tres", pos, player_id)

@rpc("reliable", "any_peer", "call_local")
func build_turret(pos: Vector2, player_id: int):
	build("res://ui/factory_items/turret.tres", pos, player_id)

@rpc("reliable", "any_peer", "call_local")
func build_energy_generator(pos: Vector2, player_id: int):
	build("res://ui/factory_items/energy_generator.tres", pos, player_id)
