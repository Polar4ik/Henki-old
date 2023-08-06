extends Node

func save(data):
	var file = FileAccess.open("user://save_data.dat", FileAccess.WRITE)
	file.store_string(str(data))

func _load():
	var file = FileAccess.open("user://save_data.dat", FileAccess.READ)
	var read = file.get_as_text()
	return read
