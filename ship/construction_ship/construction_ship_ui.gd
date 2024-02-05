extends Control

var factory: FactoryItem = ResourceLoader.load("res://ui/factory_items/factory.tres")
var energy_generator: FactoryItem = ResourceLoader.load("res://ui/factory_items/energy_generator.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_build_factory_pressed():
	var player = Global.get_player()
	if not player:
		return
	if player.resources >= factory.cost:
		player.resources -= factory.cost
		var factory_scene = factory.scene.instantiate()
		factory_scene.global_position = get_parent().get_parent().global_position	
		EventBus.on_add_to_spawner.emit(factory_scene)

func _on_build_energy_pressed():
	var player = Global.get_player()
	if not player:
		return
	if player.resources >= energy_generator.cost:
		player.resources -= energy_generator.cost
		var generator = energy_generator.scene.instantiate()
		generator.global_position = get_position_of_ship()
		print(generator)
		EventBus.on_add_to_spawner.emit(generator)

