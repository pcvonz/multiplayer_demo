extends RigidBody2D

@export var health = 40
@export var player_id = -1
@export var team: int
@onready var anim: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var well: Area2D = $well

func _ready():
	if not multiplayer.is_server():
		well.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
	if team == 0:
		anim.material.set_shader_parameter("red", 1.0)
	else: 
		anim.material.set_shader_parameter("green", 1.0)

func damage(amount: int):
	health -= amount

func _process(_delta):
	if health <= 0:
		queue_free()


func _on_body_entered(body:Node):
	print(body)
	if "value" in body:
		var value = body.value
		var player = Global.get_player()
		if player and Global.player_id == player_id:
			player.energy += value
			player.resources += value
		body.queue_free()


