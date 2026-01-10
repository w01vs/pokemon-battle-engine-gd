class_name BattleController extends Node

var _player_bottom: Trainer
var _player_top: Trainer

var _active_pokemon_bottom: Pokemon
var _active_pokemon_top: Pokemon

var _on_field: Array[Pokemon] = [_active_pokemon_bottom, _active_pokemon_top]

enum WEATHER { RAIN, SNOW, SUN, SAND, NONE }

enum TERRAIN { ELECTRIC, GRASSY, MISTY, PSYCHIC, NONE}

enum BattleState { BATTLE_START = 1, TURN_START = 2, PLAYER_CHOICE = 3, MOVE_EXEC = 4, TURN_END = 5 }

@warning_ignore("unused_private_class_variable")
var _terrain: TERRAIN = TERRAIN.NONE
@warning_ignore("unused_private_class_variable")
var _weather: WEATHER = WEATHER.NONE

var _bottom_move: Move
var _top_move: Move

enum Side { TOP, BOTTOM }
# SLOT1 = PLAYER
# SLOT2 = OPPONENT

var _state: BattleState = BattleState.BATTLE_START

@warning_ignore("unused_signal")
signal pokemon_hp_changed(hp: int, slot: Side)
signal pokemon_swap(pokemon: Pokemon, slot: Side)
signal update_text(text: String)

func initialise(player_bottom: Trainer, player_top: Trainer) -> void:
	_player_bottom = player_bottom
	_player_top = player_top

@warning_ignore("unused_parameter")
func start(player: Trainer, opponent: Trainer) -> void:
	# throw out pokemon
	set_active_pokemon(Side.BOTTOM, _player_bottom.get_active_pokemon())
	set_active_pokemon(Side.TOP, _player_top.get_active_pokemon())
	pokemon_swap.emit(_active_pokemon_top, Side.TOP)
	pokemon_swap.emit(_active_pokemon_bottom, Side.BOTTOM)
	# move to turnstart
	_state = BattleState.TURN_START

func set_active_pokemon(slot: BattleController.Side, pokemon: Pokemon) -> void:
	match slot:
		Side.BOTTOM:
			_active_pokemon_bottom = pokemon
		Side.TOP:
			_active_pokemon_top = pokemon


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	match _state:
		BattleState.BATTLE_START:
			pass
		BattleState.TURN_START:
			for pokemon in _on_field:
				#pokemon.ability.on_turn_start()
				pass
			_state = BattleState.PLAYER_CHOICE
		BattleState.PLAYER_CHOICE:
			if _player_bottom.npc and not _bottom_move:
				_bottom_move = _pick_move(BattleController.Side.BOTTOM)
			if _player_top.npc and not _top_move:
				_top_move = _pick_move(BattleController.Side.TOP)
			
			if _top_move and _bottom_move:
				_state = BattleState.MOVE_EXEC
		BattleState.MOVE_EXEC:
			# move order
			var order: Array = []
			if _active_pokemon_bottom.speed == _active_pokemon_top.speed:
				if randf() > 0.5:
					order.append(BattleController.Side.TOP)
					order.append(BattleController.Side.BOTTOM)
				else:
					order.append(BattleController.Side.BOTTOM)
					order.append(BattleController.Side.TOP)
			elif _active_pokemon_bottom.speed > _active_pokemon_top.speed:
				order.append(BattleController.Side.BOTTOM)
				order.append(BattleController.Side.TOP)
			else:
				order.append(BattleController.Side.TOP)
				order.append(BattleController.Side.BOTTOM)
			
			update_text.emit("order: " + BattleController.Side.keys()[order[0]] + " -> " + BattleController.Side.keys()[order[1]])
			

func _pick_move(side: BattleController.Side) -> Move:
	match side:
		Side.BOTTOM:
			return _active_pokemon_bottom.move1
		Side.TOP:
			return _active_pokemon_top.move1
	return null

func _receive_move(move: Move, side: BattleController.Side) -> void:
	match side:
		Side.BOTTOM:
			_bottom_move = move
		Side.TOP:
			_top_move = move
