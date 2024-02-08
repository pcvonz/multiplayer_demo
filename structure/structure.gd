class_name Structure extends StaticBody2D
@export var health = 40
@export var team: int
@export var player_id = -1
@export var preview_texture: Texture2D

func _ready():
	add_to_group("radar")
	if multiplayer.is_server():
		EventBus.on_add_static_body.emit(self)
	

