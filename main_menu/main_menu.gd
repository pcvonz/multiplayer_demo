extends Node

@export var MAX_CLIENTS = 10

func _on_client_pressed():
	var address: String = get_node("%Adress").text
	get_node("%connection_status").text = "connection to: %s" % address
	$Lobby.join_game(get_node("%name").text, address)

func _on_server_pressed():
	$Lobby.create_game(get_node("%name").text)

func _on_lobby_player_connected(peer_id:Variant, player_info:Variant):
	Global.players[peer_id] = player_info
	get_node("%GameOptions").visible = false
	get_node("%GameStatus").visible = true
	if multiplayer.is_server():
		get_node("%GameStatus").get_node("StartGame").visible = true
		
func _on_start_game_pressed():
	get_node("%StartGame").disabled = true
