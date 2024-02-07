extends Structure

@export var ore_value = 3000

func _ready():
	super()

func _on_button_pressed():
	set_harvest_ore.rpc(Global.player_id)

func mine_resource(amount: int):
	var amount_to_mine = minf(ore_value, amount)
	ore_value -= amount_to_mine
	return amount_to_mine

@rpc("any_peer", "call_local", "reliable")
func set_harvest_ore(player_id: int):
	if multiplayer.is_server():
		EventBus.on_mine_location_change.emit(self, player_id)
