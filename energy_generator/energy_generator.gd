extends StaticBody2D

@export var health = 40

func _on_timer_timeout():
	var player = Global.get_player()
	if player:
		player.energy += 10
		player.resources += 10

func damage(amount: int):
	health -= amount

func _process(delta):
	if health <= 0:
		queue_free()
