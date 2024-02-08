extends Node

# -1 is the testing player
var players: Dictionary = {
-1:{
		"resources": 1000,
		"name": "test",
		"energy": 1000,
		"team": 0
	}
}

var player_id: int = -1

var team_colors = [Color(1, 0, 0), Color(0, 1, 0)]

func get_player():
	if players.has(player_id):
		return players[player_id]

func _on_player_connected(peer_id:Variant, player_info:Variant):
	players[peer_id] = player_info

func _on_player_disconnected(peer_id:Variant):
	players.erase(peer_id)
