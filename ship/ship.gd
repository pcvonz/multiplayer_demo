extends RigidBody2D

@export var speed: float = 10.0
@export var max_speed: float = 100.0
@export var angular_speed = .1
@export var max_angular_speed = 10.0
@export var stopping_speed = 2.0
@export var health = 100.0
@onready var missile_scene = preload("res://ship/Missile/missile.tscn")
@onready var station_scene = preload("res://Turret/turret.tscn")
@onready var explode_scene = preload("res://ship/explode.tscn")
@onready var progress_bar: ProgressBar = get_node("ProgressBar")
var input: MultiplayerSynchronizer
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")

signal take_control(node: Node, player_id: int)
signal on_destroyed

func _ready():
	progress_bar.value = health
	progress_bar.max_value = health
	for player in get_tree().get_nodes_in_group("players"):
		take_control.connect(player._on_take_control)
	if not multiplayer.is_server():
		set_physics_process_internal(false)
		# Hack to stop jittery movement from physics
		freeze = true
		set_physics_process(false)

func enable_ui():
	$UI.visible = true
	
func disable_ui():
	$UI.visible = false
	
func _process(_delta):
	if health != progress_bar.value:
		progress_bar.value = health
		if health <= 0:
			anim.play("damage")
			explode()

	if input and input.place_object:
		var station = station_scene.instantiate()
		station.global_position = input.placement_position + global_position
		input.place_object = false

		EventBus.on_add_to_spawner.emit(station)
	if input and input.primary_weapon:
		input.primary_weapon = false
		var missile = missile_scene.instantiate()
		missile.add_collision_exception_with(self)
		missile.rotation = self.rotation
		missile.global_position = self.global_position
		missile.linear_velocity = self.linear_velocity
		
		EventBus.on_add_to_spawner.emit(missile)

func damage(amount: float):
	health -= amount

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	var explode_instance = explode_scene.instantiate()
	explode_instance.starting_linear_velocity = linear_velocity
	explode_instance.global_position = global_position
	EventBus.on_add_to_spawner.emit(explode_instance)
	on_destroyed.emit()
	for child in get_children():
		if "visible" in child:
			child.visible = false
	$explosion.visible = true
	$explosion.explode()
	var timer = Timer.new()
	add_child(timer)
	timer.start(5.0)
	timer.timeout.connect(_on_explode_timeout)
	disable_ui()

func _on_explode_timeout():
	queue_free()

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if !input:
		return
	if input.thrust_engaged:
		var speed_to_add= (Vector2(0, clampf(speed, 0, speed)).rotated(self.rotation))
		state.linear_velocity -= speed_to_add
	if input.rotating_port:
		state.angular_velocity = clampf(state.angular_velocity - angular_speed, -max_angular_speed, max_angular_speed)
	if input.rotating_starboard:
		state.angular_velocity = clampf(state.angular_velocity + angular_speed, -max_angular_speed, max_angular_speed)
	if input.brake_engaged:
		var stoppign_velocity = (linear_velocity.normalized() * stopping_speed)
		linear_velocity -= stoppign_velocity
		
func _on_button_pressed():
	if input == null:
		take_control.emit(self, multiplayer.get_unique_id())
		enable_ui()

