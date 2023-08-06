extends Area3D

var damage = 30

var target = G.player

func _ready() -> void:
	rotation_degrees.y

func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.final:
			body.hp -= damage
		else:
			body.hp -= damage / 2
