extends StaticBody2D

var progress_bar: ProgressBar
var get_closest_node_in_group = preload("res://util/get_closest_node_in_group.gd")

@export var health = 100
@export var team: int
@export var max_distance = 1000 
@export var missile_scene: PackedScene

func damage(amount: int):
	health -= amount

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	progress_bar.max_value = health
	$Timer.timeout.connect(_on_timeout)
	if team != null:
		$Sprite2D.modulate=Global.team_colors[team]

func _process(delta):
	progress_bar.value = health
	var closest_player = get_closest_node_in_group.run("ships", team, self, max_distance)
	if closest_player != null:
		look_at(closest_player.global_position)
	if health <= 0:
		queue_free()

func _on_timeout():
	var closest_player = get_closest_node_in_group.run("ships", team, self, max_distance)
	if closest_player == null:
		return
		
	var missile: RigidBody2D = missile_scene.instantiate()
	missile.add_collision_exception_with(self)
	missile.global_position = self.global_position
	missile.look_at(closest_player.global_position)
	missile.rotation = missile.rotation + ( PI / 2 )
	
	EventBus.on_add_to_spawner.emit(missile)
