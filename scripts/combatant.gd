class_name Combatant

var id: int
var side: BattleController.Side
var resource: Pokemon
var _slot: int

var _ai: bool = false

var selected_move_idx: int = -1
var ready: bool = false
var selected_targets: Array[Combatant] = []

func _init(resource_: Pokemon, side_: BattleController.Side, slot: int, ai: bool) -> void:
	resource = resource_
	side = side_
	id = resource.get_instance_id()
	_slot = slot
	_ai = ai
