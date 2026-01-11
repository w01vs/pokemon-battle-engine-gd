class_name Ability extends Resource

@warning_ignore("unused_parameter")
func on_turn_start(user: Pokemon) -> void:
	pass

@warning_ignore("unused_parameter")
func on_switch_in(user: Pokemon, opponent: Pokemon) -> void:
	pass

@warning_ignore("unused_parameter")
func on_damage_taken(user: Pokemon, damage: int) -> void: 
	pass

@warning_ignore("unused_parameter")
func on_damage_dealt(user: Pokemon, damage: int) -> void:
	pass

#func on_type_check(user: Pokemon, move_type, target: Pokemon): 
	#return null

@warning_ignore("unused_parameter")
func on_move_use(user: Pokemon, move: Move) -> void: 
	pass

#func on_status_inflict(target, status): 
	#return true  # allow by default
