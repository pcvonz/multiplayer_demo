extends Area2D

@onready var missile_scene = preload("res://ship/Missile/missile.tscn")

@export var team: int
var max_distance = 1000 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_timeout)
	if team != null:
		$Sprite2D.modulate=Global.team_colors[team]

func _on_timeout():
		var closest_player 
		for ship in get_tree().get_nodes_in_group("ships"):
			if ship.team != team:
				var distance_to: float = self.global_position.distance_to(ship.global_position)
				if distance_to < max_distance:
					if !closest_player:
						closest_player = ship
					else:
						var current_closest_distance = self.global_position.distance_to(closest_player.global_position)
						if current_closest_distance > distance_to and ship.team != team:
							closest_player = ship

		if closest_player == null:
			return
			
		var missile: RigidBody2D = missile_scene.instantiate()
		missile.global_position = self.global_position
		missile.look_at(closest_player.global_position)
		missile.rotation = missile.rotation + ( PI / 2 )
		
		EventBus.on_add_to_spawner.emit(missile)
