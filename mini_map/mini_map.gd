extends Control

var player: Player
@export var zoom = 1.5:
	set = set_zoom

func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = size / (get_viewport_rect().size * zoom)

@export var player_texture: Texture2D
@export var ship_texture: Texture2D
@export var harvester: Texture2D
@export var structure_texture: Texture2D
var grid_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_scale = size / (get_viewport_rect().size * zoom)
	for p in get_tree().get_nodes_in_group("players"):
		if p.player_id == Global.player_id:
			player = p

func _process(_delta):
	queue_redraw()

func filter_func(node: Node2D):
	var player = Global.get_player()
	if "player_id" in node and "team" in node:
		return node.player_id == Global.player_id or player.team == node.team
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_map_position(player_pos: Vector2, object_pos: Vector2):
	var map_pos = (object_pos - player_pos) * grid_scale + size / 2
	map_pos = map_pos.clamp(Vector2.ZERO, size)
	return map_pos
	
func _draw():
	if !player:
		return
	var player_pos = player.get_player_position()
	for node in get_tree().get_nodes_in_group("radar").filter(filter_func):
		if node is Ship:
			var ship_pos = get_map_position(player_pos, node.global_position)
			draw_texture(ship_texture, ship_pos)
		if node is Structure:
			var structure_pos = get_map_position(player_pos, node.global_position)
			draw_texture(structure_texture, structure_pos)
		if node is Harvester:
			var harvester_pos = get_map_position(player_pos, node.global_position)
			draw_texture(harvester, harvester_pos)

		draw_texture(player_texture, get_map_position(player_pos, player_pos))
	

func _on_gui_input(event):
	if event.is_action("zoom_in"):
		zoom += .1
	if event.is_action("zoom_out"):
		zoom -= .1
