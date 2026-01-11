extends Control

@export var _side: BattleController.Side

@onready var _move1_button: Button = $"Button"
@onready var _move2_button: Button = $"Button2"
@onready var _move3_button: Button = $"Button3"
@onready var _move4_button: Button = $"Button4"

@export var _controller: BattleController

var moves: Array[Move] = []
var movebuttons: Array[Button] = []
var _id: int

func _ready() -> void:
	movebuttons = [_move1_button, _move2_button, _move3_button, _move4_button]
	

func opposite() -> BattleController.Side:
	if _side == BattleController.Side.BOTTOM:
		return BattleController.Side.TOP
	return BattleController.Side.BOTTOM

func _on_battle_controller_pokemon_swap(id: int, pokemon: Pokemon, side: BattleController.Side) -> void:
	_id = id
	if side == _side:
		for idx in range(0, movebuttons.size()):
			if pokemon.moves.size() > idx and pokemon.moves[idx]:
				movebuttons[idx].text = pokemon.moves[idx].name
			else:
				movebuttons[idx].text = ""
				movebuttons[idx].disabled = true

func send_move(idx: int) -> void:
	#@need more target selection things
	var target: Combatant = _controller.get_pokemon(_side, opposite())
	_controller._receive_move(idx, _id, [target])

func _on_move1() -> void:
	send_move(0)

func _on_move2() -> void:
	send_move(1)

func _on_move3() -> void:
	send_move(2)

func _on_move4() -> void:
	send_move(3)
