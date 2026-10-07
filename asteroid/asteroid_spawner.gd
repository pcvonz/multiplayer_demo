extends Node2D

@onready var timer: Timer = get_node("Timer")

func spawn_asteroid():
	var asteroid: NetworkRigidBody2D = preload("res://asteroid/asteroid.tscn").instantiate()
	var x = randf_range(-100, 100)
	var y = randf_range(-100, 100)
	var pos_x = randf_range(-100, 100)
	var pos_y = randf_range(-100, 100)
	asteroid.linear_velocity = Vector2(x, y)
	asteroid.position = Vector2(pos_x, pos_y)
	add_child(asteroid, true)

func _on_timer_timeout():
	if multiplayer.is_server():
		spawn_asteroid()
