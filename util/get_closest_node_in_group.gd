extends Node2D

static func run(group: String, team: int, node: Node2D, max_distance: float) -> Node2D:
	var closest_player 
	for ship in node.get_tree().get_nodes_in_group(group):
		if ship.team != team:
			var distance_to: float = node.global_position.distance_to(ship.global_position)
			if distance_to < max_distance:
				if !closest_player:
					closest_player = ship
				else:
					var current_closest_distance = node.global_position.distance_to(closest_player.global_position)
					if current_closest_distance > distance_to and ship.team != team:
						closest_player = ship
	return closest_player	


