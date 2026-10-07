extends NetworkRigidBody2D

@export var health = 20
@export var value = 10
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_timeout)
	timer.wait_time = randf_range(30, 50)

func _on_timeout():
	queue_free()

func damage(amount: int):
	timer.paused = true
	health -= amount

func explode():
	queue_free()

func _physics_rollback_tick(_delta, _tick):
	if health <= 0:
		explode()
