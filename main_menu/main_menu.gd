extends Control

@export var MAX_CLIENTS = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_client_pressed():
	var IP_ADDRESS: String = get_node("%Adress").text
	$Lobby.join_game(get_node("%name").text, IP_ADDRESS)

func _on_server_pressed():
	$Lobby.create_game(get_node("%name").text)

func update_players():
	var player_label = get_node("%Players")
	player_label.text = "Players: \n"
	for player in Global.players.values():
		player_label.text += "%s\n" % player.name

# TODO: Handle when server disconnects
func _on_lobby_player_disconnected(peer_id:Variant):
	update_players()

func _on_lobby_player_connected(peer_id:Variant, player_info:Variant):
	Global.players[peer_id] = player_info
	get_node("%GameOptions").visible = false
	get_node("%GameStatus").visible = true
	update_players()
	if multiplayer.is_server():
		get_node("%GameStatus").get_node("StartGame").visible = true
		
func _on_start_game_pressed():
	start_game()

func start_game():
	# Hide the UI and unpause to start the game.
	hide_menu.rpc()
	self.hide()
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://World/world.tscn"))


@rpc("authority", "reliable")
func hide_menu():
	self.hide()

# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = get_node("../Level")
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())

# The server can restart the level by pressing Home.
func _input(event):
	if not multiplayer.is_server():
		return
	if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		change_level.call_deferred(load("res://level.tscn"))
