extends StaticBody2D

@export var ore_value = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_button_pressed():
	set_harvest_ore.rpc(Global.player_id)

@rpc("any_peer", "call_local", "reliable")
func set_harvest_ore(player_id: int):
	if multiplayer.is_server():
		for harvest_factory in get_tree().get_nodes_in_group("harvest_factories"):
			if harvest_factory.player_id == player_id:
				harvest_factory.set_mine_location(self)
