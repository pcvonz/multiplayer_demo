extends RigidBody2D

@export var health = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	if not multiplayer.is_server():
		freeze = true

func damage(amount: int):
	health -= amount

func explode():
	queue_free()

func _process(delta):
	if health <= 0:
		explode()
