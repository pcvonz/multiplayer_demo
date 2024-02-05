extends Node

var players: Dictionary = {}

var player_id: int = -1

func get_player():
	if players.has(player_id):
		return players[player_id]

func _on_player_connected(peer_id:Variant, player_info:Variant):
	players[peer_id] = player_info

func _on_player_disconnected(peer_id:Variant):
	players.erase(peer_id)
