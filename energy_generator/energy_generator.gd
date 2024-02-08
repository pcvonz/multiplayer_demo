extends Structure 

@onready var anim: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var well: Area2D = $well

func _ready():
	super()
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
	if "value" in body:
		var value = body.value
		add_resources.rpc(player_id, value)
		body.queue_free()

@rpc("authority", "call_local")
func add_resources(id: int, value: int):
	var player = Global.players[id]
	player.energy += value
	player.resources += value

