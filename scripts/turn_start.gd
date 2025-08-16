class_name TurnStart extends BattleState

func update(delta: float, params: Dictionary) -> Dictionary:
	var pokemon: Array[Pokemon] = params.on_field
	for poke in pokemon:
		# ability
		#poke.ability.on_turn_start(poke)
		# item
		#poke.item.on_turn_start(poke)
		pass
	
	return params
