extends Node3D

var canSpawn := false
var rng = RandomNumberGenerator.new()
var enemyList = ["res://Object/Enemy/BatKnight.tscn", "res://Object/Enemy/BatWizzard.tscn"]
var enemyListPointer

var SceneList = []

var timer

func _ready() -> void:
	randomize()
	timer = Timer.new()
	timer.wait_time = rng.randi_range(5,10)
	add_child(timer)
	timer.timeout.connect(timeout)
	timer.start()
	
	await get_tree().create_timer(7).timeout
	canSpawn = true

func _process(delta: float) -> void:
#	print(SceneList)
	if G.player != null:
		spawn()

func spawn():
	if canSpawn and SceneList.size() < 1:
		enemyListPointer = rng.randi_range(0,1)
		var enem = load(enemyList[enemyListPointer]).instantiate()
		enem.position = position
		$"../Sp".add_child(enem)
		canSpawn = false
		timer.wait_time = rng.randi_range(5,10)
		timer.start()
		SceneList.append(enem)
		enem.dieS.connect(delete_from_scene)

func delete_from_scene():
	SceneList.clear()

func timeout():
	canSpawn = true
