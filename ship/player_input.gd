extends BaseNetInput
class_name PlayerInput

@export var thrust_engaged := false
@export var rotating_port := false
@export var rotating_starboard := false
@export var brake_engaged := false
@export var primary_weapon := false
@export var place_object := false
@export var placement_position: Vector2

func set_brake(state: bool):
	brake_engaged = state

func set_rotate_port(state: bool):
	rotating_port = state

func set_rotate_starboard(state: bool):
	rotating_starboard = state 

func set_thrust_engaged(state: bool):
	thrust_engaged = state

@rpc("call_local")
func activate_primary_weapon():
	primary_weapon = true

func activate_place_object():
	place_object = true

func _gather():
	if Input.is_action_pressed("ui_up"):
		thrust_engaged = true
	else:
		thrust_engaged = false

	if Input.is_action_pressed("ui_left"):
		rotating_port = true
	else:
		rotating_port = false

	if Input.is_action_pressed("ui_right"):
		rotating_starboard = true
	else:
		rotating_starboard = false

	if Input.is_action_pressed("ui_down"):
		brake_engaged = true
	else:
		brake_engaged = false

	if Input.is_action_pressed("fire"):
		activate_primary_weapon.rpc()

	# if Input.is_action_released("click"):
	# 	# Disabling to work on factory feature
	# 	return
	# 	var mouse_event: InputEventMouse = event
	# 	var mouse_position = mouse_event.position
	# 	placement_position = mouse_position - (get_viewport().get_visible_rect().size / 2)
		
		#activate_place_object()
