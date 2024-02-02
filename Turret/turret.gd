extends Area2D

@onready var missile_scene = preload("res://ship/Missile/missile.tscn")

signal on_tower_event(node: Node)
var max_distance = 1000 
var player_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_timeout)

func setup(world: Node, spawner: Node):
	on_tower_event.connect(world._on_add_to_spawner)

func _on_timeout():
		var closest_player 
		for player in get_tree().get_nodes_in_group("players"):
			var distance_to: float = self.global_position.distance_to(player.global_position)
			if distance_to < max_distance:
				if !closest_player:
					closest_player = player
				else:
					var current_closest_distance = self.global_position.distance_to(closest_player.global_position)
					if current_closest_distance > distance_to:
						closest_player = player

		if closest_player == null:
			return
			
		var missile: RigidBody2D = missile_scene.instantiate()
		missile.global_position = self.global_position
		missile.look_at(closest_player.global_position)
		missile.rotation = missile.rotation + ( PI / 2 )
		
		on_tower_event.emit(missile)
