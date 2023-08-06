extends Node

var player
var weapon
var canvas
var enemys # не нужен
var camera

var kills: int

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
