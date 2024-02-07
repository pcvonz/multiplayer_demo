class_name Factory extends Structure

@onready var timer: Timer = get_node("Timer")
@onready var progress: ProgressBar = get_node("ProgressBar")
@onready var spawner: MultiplayerSpawner = get_node("MultiplayerSpawner")

@export var build_queue: Array[FactoryItem] = []
var currently_building: FactoryItem
@export var percent_left: float
@export var build_time: float = 0
@export var maximum_items = 30

signal build_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if multiplayer.is_server():
		timer.timeout.connect(_on_timeout)

func _on_timeout():
	build_complete.emit()
	spawn_scene()
	build_queue.pop_front()
	timer.stop()
	if not is_spawner_full() and len(build_queue) > 0:
		start_building()
		
func is_spawner_full():
	return get_node("spawn_pos").get_child_count() >= maximum_items

func get_new_spawn_pos():
	var num_children = len(get_node("spawn_pos").get_children())
	var x = ( num_children * 100 ) - ((num_children / 5) * 500)
	var y = ( num_children / 5 ) * 100
	return Vector2(x, y)
		
func spawn_scene():
	var scene = currently_building.scene.instantiate()
	scene.team = team
	scene.position = get_new_spawn_pos()
	var spawn_node = spawner.get_node(spawner.spawn_path)
	spawn_node.call_deferred("add_child", scene, true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if currently_building and multiplayer.is_server():
		build_time = currently_building.build_time
		percent_left =  (timer.time_left / build_time) * 100

	progress.value = 100 - percent_left
	if health <= 0:
		queue_free()

func damage(amount: int):
	health -= amount
	
func start_building():
	currently_building = build_queue.pop_front()
	timer.start(currently_building.build_time)
	spawner.add_spawnable_scene(currently_building.scene.resource_path)

func _on_purchase(item: FactoryItem):
	build_queue.push_back(item)
	if timer.is_stopped():
		start_building()
