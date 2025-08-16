class_name Trainer extends Resource

@export var name: String
@export var team: Array[Pokemon]
var active_index: int = 0

func _ready() -> void:
	pass
func get_active_pokemon() -> Pokemon:
	return team[active_index]
