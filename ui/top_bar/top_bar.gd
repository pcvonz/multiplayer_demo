extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_id != multiplayer.get_unique_id():
		visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_id = Global.player_id
	if Global.players.has(player_id):
		get_node("%resources").text = "Resources: %s" % Global.players[player_id].resources
		get_node("%energy").text = "Energy: %s" % Global.players[player_id].energy
		get_node("%name").text = "Name: %s (%s)" % [ Global.players[player_id].name, Global.player_id]
