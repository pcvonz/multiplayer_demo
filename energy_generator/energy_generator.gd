extends StaticBody2D

@export var health = 40
@export var player_id = -1
@export var team: int
@onready var anim: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	if team == 0:
		anim.material.set_shader_parameter("red", 1.0)
	else: 
		anim.material.set_shader_parameter("green", 1.0)

func _on_timer_timeout():
	var player = Global.get_player()
	if player and Global.player_id == player_id:
		player.energy += 10
		player.resources += 10

func damage(amount: int):
	health -= amount

func _process(_delta):
	if health <= 0:
		queue_free()
