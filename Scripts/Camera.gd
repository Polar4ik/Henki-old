extends Camera3D

@onready var player: CharacterBody3D = $"../Player"

func _process(delta: float) -> void:
	if player != null:
		position.x = lerp(position.x, player.position.x, delta * 2)
		position.z = lerp(position.z, player.position.z + 5, delta * 2)
