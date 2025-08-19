class_name BattleController extends Node

var _player_1: Trainer
var _player_2: Trainer

var active_pokemon_p1: Pokemon
var active_pokemon_p2: Pokemon

enum WEATHER { RAIN, SNOW, SUN, SAND, NONE }

enum TERRAIN { ELECTRIC, GRASSY, MISTY, PSYCHIC, NONE}

var terrain: TERRAIN = TERRAIN.NONE
var weather: WEATHER = WEATHER.NONE

enum UI {SLOT1, SLOT2}
# SLOT1 = PLAYER
# SLOT2 = OPPONENT

signal pokemon_hp_changed(hp: int, slot: UI)
signal pokemon_swap(pokemon: String, slot: UI)

func initialise(player_1: Trainer, player_2: Trainer) -> void:
	_player_1 = player_1
	_player_2 = player_2
	active_pokemon_p1 = _player_1.get_active_pokemon()
	active_pokemon_p2 = _player_2.get_active_pokemon()

func start(player: Trainer, opponent: Trainer) -> void:
	# throw out pokemon
	set_active_pokemon(UI.SLOT1, _player_1.get_active_pokemon())
	set_active_pokemon(UI.SLOT2, _player_2.get_active_pokemon())
	# move to turnstart


func set_active_pokemon(slot: UI, pokemon: Pokemon) -> void:
	match slot:
		UI.SLOT1:
			active_pokemon_p1 = pokemon
		UI.SLOT2:
			active_pokemon_p2 = pokemon
