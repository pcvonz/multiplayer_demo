class_name BuildPreview extends Node2D

var item: FactoryItem
@onready var timer: Timer = $Timer
@onready var preview: Sprite2D = $Sprite2D
@onready var progress_bar: ProgressBar = $ProgressBar
@export var team: int = -1
@export var player_id: int = -1
@export var percent_complete: float
@export var resource_path: String

var scene_to_build: Structure

func get_preview_texture(scene: Structure):
	if scene.preview_texture:
		return scene.preview_texture
	if scene.has_node("Sprite2D"):
		return scene.get_node("Sprite2D").texture

func _process(_delta):
	if item == null and resource_path:
		item = ResourceLoader.load(resource_path)
		scene_to_build = item.scene.instantiate()
		preview.texture = get_preview_texture(scene_to_build)
		if multiplayer.is_server():
			timer.wait_time = item.build_time
			timer.start()

	if multiplayer.is_server():
		percent_complete = 1 - (timer.time_left / timer.wait_time)

	progress_bar.value = percent_complete * 100
	preview.modulate = Color(preview.modulate.r, preview.modulate.g, preview.modulate.b, percent_complete)

func _on_scene_built():
	queue_free()

func _on_timer_timeout():
	if multiplayer.is_server():
		scene_to_build.player_id = player_id
		scene_to_build.team = team
		scene_to_build.global_position = self.global_position
		scene_to_build.tree_entered.connect(_on_scene_built)
		EventBus.on_add_to_spawner.emit(scene_to_build)
