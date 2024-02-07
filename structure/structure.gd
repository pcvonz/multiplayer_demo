class_name Structure extends StaticBody2D
@export var health = 40
@export var team: int
@export var player_id = -1

func _ready():
	if multiplayer.is_server():
		EventBus.on_add_static_body.emit(self)
	

