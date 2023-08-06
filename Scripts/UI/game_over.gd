extends Control

func _ready() -> void:
	if G.kills > int(Save._load()):
		Save.save(G.kills) 

func _on_restart_pressed() -> void:
	var game = load("res://Scene/World.tscn").instantiate()
	get_parent().get_parent().get_parent().add_child(game)
	get_parent().get_parent().queue_free()
	G.kills = 0


func _on_menu_pressed() -> void:
	var menu = load("res://Object/UI/main_menu.tscn").instantiate()
	get_parent().get_parent().get_parent().add_child(menu)
	get_parent().get_parent().queue_free()
