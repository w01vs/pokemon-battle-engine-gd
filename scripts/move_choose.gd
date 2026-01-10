extends Control

@export var side: BattleController.Side

@onready var _move1_button: Button = $"Button"
@onready var _move2_button: Button = $"Button2"
@onready var _move3_button: Button = $"Button3"
@onready var _move4_button: Button = $"Button4"

@export var _controller: BattleController

var _move1: Move
var _move2: Move
#var _move3: Move
#var _move4: Move

func _on_battle_controller_pokemon_swap(pokemon: Pokemon, slot: BattleController.Side) -> void:
	if slot == BattleController.Side.BOTTOM:
		if not pokemon.move1:
			_move1_button.text = "empty"
			_move1_button.disabled = true
		else:
			_move1 = pokemon.move1
			_move1_button.text = _move1.name
		if not pokemon.move2:
			_move2_button.text = "empty"
			_move2_button.disabled = true
		else:
			_move2 = pokemon.move2
			_move2_button.text = _move2.name
		_move3_button.disabled = true
		_move4_button.disabled = true

func _on_move1() -> void:
	_controller._receive_move(_move1, side)

func _on_move2() -> void:
	_controller._receive_move(_move2, side)

func _on_move3() -> void:
	#_controller._receive_move(_move3, side)
	pass

func _on_move4() -> void:
	#_controller._receive_move(_move4, side)
	pass
