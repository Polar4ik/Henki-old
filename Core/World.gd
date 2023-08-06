extends Node

func _ready() -> void:
	G.player = $Location/Player
	G.weapon = $Location/Player/Weapon
	G.canvas = $Canvas
	G.camera = $Location/Camera
	G.enemys = []
	
func _process(delta: float) -> void:
	for i in $Location/SpawnPoint/Sp.get_child_count():
		G.enemys.push_back($Location/SpawnPoint/Sp.get_child(i))
#		print($Location/SpawnPoint/Sp.get_child(i))
	
#	print(G.enemys)
