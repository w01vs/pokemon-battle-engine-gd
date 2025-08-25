class_name BattleController extends Node

var _player_1: Trainer
var _player_2: Trainer

var _active_pokemon_p1: Pokemon
var _active_pokemon_p2: Pokemon

var _on_field: Array[Pokemon] = [_active_pokemon_p1, _active_pokemon_p2]

enum WEATHER { RAIN, SNOW, SUN, SAND, NONE }

enum TERRAIN { ELECTRIC, GRASSY, MISTY, PSYCHIC, NONE}

enum BattleState { BATTLE_START, TURN_START, PLAYER_CHOICE, MOVE_EXEC, TURN_END }

var _terrain: TERRAIN = TERRAIN.NONE
var _weather: WEATHER = WEATHER.NONE

enum UI {SLOT1, SLOT2}
# SLOT1 = PLAYER
# SLOT2 = OPPONENT

var _state: BattleState = BattleState.TURN_START

signal pokemon_hp_changed(hp: int, slot: UI)
signal pokemon_swap(pokemon: Pokemon, slot: UI)

func initialise(player_1: Trainer, player_2: Trainer) -> void:
	_player_1 = player_1
	_player_2 = player_2
	_active_pokemon_p1 = _player_1.get_active_pokemon()
	_active_pokemon_p2 = _player_2.get_active_pokemon()

func start(player: Trainer, opponent: Trainer) -> void:
	# throw out pokemon
	set_active_pokemon(UI.SLOT1, _player_1.get_active_pokemon())
	set_active_pokemon(UI.SLOT2, _player_2.get_active_pokemon())
	# move to turnstart

func set_active_pokemon(slot: UI, pokemon: Pokemon) -> void:
	match slot:
		UI.SLOT1:
			_active_pokemon_p1 = pokemon
		UI.SLOT2:
			_active_pokemon_p2 = pokemon


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
			# wait for signal from UI.
			pass
		
		
