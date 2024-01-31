extends MultiplayerSynchronizer

@export var thrust_engaged := false
@export var rotating_port := false
@export var rotating_starboard := false
@export var brake_engaged := false
@export var primary_weapon := false
@export var place_object := false
@export var placement_position: Vector2


@rpc("call_local")
func set_brake(state: bool):
	brake_engaged = state

@rpc("call_local")
func set_rotate_port(state: bool):
	rotating_port = state

@rpc("call_local")
func set_rotate_starboard(state: bool):
	rotating_starboard = state 

@rpc("call_local")
func set_thrust_engaged(state: bool):
	thrust_engaged = state

@rpc("call_local")
func activate_primary_weapon():
	primary_weapon = true

@rpc("call_local")
func activate_place_object():
	place_object = true

func _ready():
	set_process_input(get_multiplayer_authority() == multiplayer.get_unique_id())

func _input(event):
	if event.is_action_pressed("ui_up"):
		set_thrust_engaged.rpc(true)
	if event.is_action_released("ui_up"):
		set_thrust_engaged.rpc( false )

	if event.is_action_pressed("ui_left"):
		set_rotate_port.rpc( true )
	if event.is_action_released("ui_left"):
		set_rotate_port.rpc( false )

	if event.is_action_pressed("ui_right"):
		set_rotate_starboard.rpc( true )
	if event.is_action_released("ui_right"):
		set_rotate_starboard.rpc( false )

	if event.is_action_pressed("ui_down"):
		set_brake.rpc( true )
	if event.is_action_released("ui_down"):
		set_brake.rpc( false )

	if event.is_action_pressed("fire"):
		activate_primary_weapon.rpc()

	if event.is_action_released("click"):
		var mouse_event: InputEventMouse = event
		var mouse_position = mouse_event.position
		placement_position = mouse_position - (get_viewport().get_visible_rect().size / 2)
		
		activate_place_object()

