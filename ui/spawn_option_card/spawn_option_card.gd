extends VBoxContainer
@export var item: FactoryItem

signal purchase(item: FactoryItem)

func _ready():
	$Label.text = item.item_name

func _on_gui_input(event:InputEvent):
	if event.is_action_released("click"):
		var player = Global.get_player()
		if player.resources >= item.cost:
			player.resources -= item.cost
			select_item.rpc()
	
@rpc("any_peer", "call_local", "reliable", 0)
func select_item():
	if multiplayer.is_server():
		purchase.emit(item)

		
