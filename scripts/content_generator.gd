class_name ContentGenerator

func get_move(name: String) -> Move:
	var path: String = "res://resources/Moves/" + name + ".tres"
	var move: Move = load(path).duplicate()
	return move
