extends Node2D

@onready var timer: Timer = get_node("Timer")

@onready var asteroid_scene = preload("res://asteroid/asteroid.tscn")

func spawn_asteroid():
	var asteroid: RigidBody2D = asteroid_scene.instantiate()
	var x = randf_range(-100, 100)
	var y = randf_range(-100, 100)
	var pos_x = randf_range(-1000, 1000)
	var pos_y = randf_range(-1000, 1000)
	asteroid.linear_velocity = Vector2(x, y)
	asteroid.global_position = Vector2(pos_x, pos_y)
	add_child(asteroid, true)

func _on_timer_timeout():
	if multiplayer.is_server():
		spawn_asteroid()

