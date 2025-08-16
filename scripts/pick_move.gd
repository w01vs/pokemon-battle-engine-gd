class_name PickMove extends BattleState


func update(delta: float, params: Dictionary) -> Dictionary:
	var user: Pokemon = params.user
	if Input.is_action_just_pressed("move 1"):
		pass
	elif Input.is_action_just_pressed("move 2"):
		pass
	return params
