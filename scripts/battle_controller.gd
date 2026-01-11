class_name BattleController extends Node

var _player_bottom: Trainer
var _player_top: Trainer

var LEVEL: int = 1


var combatants: Dictionary[int, Combatant]

enum WEATHER { RAIN, SNOW, SUN, SAND, NONE }

enum TERRAIN { ELECTRIC, GRASSY, MISTY, PSYCHIC, NONE}

enum BattleState { BATTLE_START = 1, TURN_START = 2, PLAYER_CHOICE = 3, MOVE_EXEC = 4, TURN_END = 5 }

@warning_ignore("unused_private_class_variable")
var _terrain: TERRAIN = TERRAIN.NONE
@warning_ignore("unused_private_class_variable")
var _weather: WEATHER = WEATHER.NONE

enum Side { TOP, BOTTOM }
# SLOT1 = PLAYER
# SLOT2 = OPPONENT

var _state: BattleState = BattleState.BATTLE_START

@warning_ignore("unused_signal")
signal pokemon_hp_changed(id: int, hp: int)
@warning_ignore("unused_signal")
signal pokemon_swap(id: int, pokemon: Pokemon)
signal pokemon_start(id: int, pokemon: Pokemon, side: Side)
signal update_text(text: String)

func initialise(player_bottom: Trainer, player_top: Trainer) -> void:
	_player_bottom = player_bottom
	_player_top = player_top

@warning_ignore("unused_parameter")
func start(player: Trainer, opponent: Trainer) -> void:
	# throw out pokemon
	var p1: Combatant = set_active_pokemon(_player_bottom.get_active_pokemon(), Side.BOTTOM, false)
	var p2: Combatant = set_active_pokemon(_player_top.get_active_pokemon(), Side.TOP, true)
	pokemon_start.emit(p1.id, p1.resource, Side.BOTTOM)
	pokemon_start.emit(p1.id, p2.resource, Side.TOP)
	# move to turnstart
	_state = BattleState.TURN_START

func set_active_pokemon(pokemon: Pokemon, side: BattleController.Side, ai: bool) -> Combatant:
	var combatant: Combatant = Combatant.new(pokemon, side, 0, ai)
	combatants[combatant.id] = combatant
	return combatant


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	match _state:
		BattleState.BATTLE_START:
			pass
		BattleState.TURN_START:
			for pokemon in combatants.values():
				#pokemon.ability.on_turn_start()
				pass
			_state = BattleState.PLAYER_CHOICE
		BattleState.PLAYER_CHOICE:
			var move_ready: bool = true
			for comb in combatants.values():
				if comb._ai:
					_pick_move(comb.id)
				move_ready = comb.ready && move_ready
			if move_ready:
				_state = BattleState.MOVE_EXEC
		BattleState.MOVE_EXEC:
			# move order
			var order: Array[Combatant] = combatants.values()
			#weather?
			#terrain?
			order.sort_custom(speed_sort)
			#ailments?
			#trickroom etc?
			update_text.emit("order: " + order[0].resource.name + " -> " + order[1].resource.name)
			# do the actual moves.
			

func speed_sort(a: Combatant, b: Combatant) -> bool:
	if a.resource.speed == b.resource.speed:
		if randf() > 0.5:
			return true
		else:
			return false
	if a.resource.speed > b.resource.speed:
		return true
	else:
		return false

func _pick_move(id: int) -> void:
	combatants[id].selected_move_idx = 1
	combatants[id].selected_targets = get_opposing_pokemon(id)
	combatants[id].ready = true


func _receive_move(moveidx: int, id: int, targets: Array[Combatant]) -> void:
	if combatants.has(id):
		combatants[id].selected_move_idx = moveidx
		combatants[id].selected_targets = targets
		combatants[id].ready = true

func get_pokemon_id(side: BattleController.Side, slot: int) -> int:
	return combatants.values()[combatants.values().find_custom(func(comb): return comb.side == side && comb.slot == slot)].id

func get_pokemon(side: BattleController.Side, slot: int) -> Combatant:
	return combatants.values()[combatants.values().find_custom(func(comb): return comb.side == side && comb._slot == slot)]

func get_pokemon_by_id(id: int) -> Combatant:
	return combatants[id]

func get_opposing_pokemon(id: int) -> Array[Combatant]:
	var res: Array[Combatant]
	for c in combatants.values():
		if c.side != combatants[id].side:
			res.append(c)
	return res

func apply_move(userid: int, targets: Array[Combatant]) -> void:
	var user: Combatant = combatants[userid]
	var target: Combatant = targets[0]
	var move: Move = user.resource.moves[user.selected_move_idx]
	if move.damage_type != Global.DamageType.STATUS:
		# roll crit chance here
		var crit: float = 1.5
		# check stab here
		var stab: float = 1.5
		var burn: float = 1
		var type_effectiveness: float = 1
		var damage: float = ((2*LEVEL) / 5 + 2) * move.power * user.resource.atk_stat / target.resource.def_stat / 50 + 2
		var dmg_with_mul: float = damage \
									* targets.size() \
									#* parental bond stat \
									#* weather \
									#* glaiverush \
									* crit \
									* randf_range(0.85, 1.0) \
									* stab \
									* burn
		target.resource.hp = roundf(dmg_with_mul)
		
