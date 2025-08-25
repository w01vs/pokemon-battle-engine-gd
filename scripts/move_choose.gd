extends Control

@onready var _move1_button: Button = $"Button"
@onready var _move2_button: Button = $"Button2"
@onready var _move3_button: Button = $"Button3"
@onready var _move4_button: Button = $"Button4"

var _move1: Move
var _move2: Move
var _move3: Move
var _move4: Move

func _on_battle_controller_pokemon_swap(pokemon: Pokemon, slot: BattleController.UI) -> void:
	if slot == BattleController.UI.SLOT1:
		_move1 = pokemon.move1
		_move2 = pokemon.move2
		_move3 = pokemon.move3
		_move4 = pokemon.move4
