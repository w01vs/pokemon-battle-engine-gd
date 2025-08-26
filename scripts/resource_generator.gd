class_name ResourceGenerator

# Mappings from JSON string values to enums
const TYPE_MAP: Dictionary = {
	"bug": Global.Type.BUG,
	"dark": Global.Type.DARK,
	"dragon": Global.Type.DRAGON,
	"electric": Global.Type.ELECTRIC,
	"fairy": Global.Type.FAIRY,
	"fighting": Global.Type.FIGHTING,
	"fire": Global.Type.FIRE,
	"flying": Global.Type.FLYING,
	"ghost": Global.Type.GHOST,
	"grass": Global.Type.GRASS,
	"ground": Global.Type.GROUND,
	"ice": Global.Type.ICE,
	"normal": Global.Type.NORMAL,
	"poison": Global.Type.POISON,
	"psychic": Global.Type.PSYCHIC,
	"steel": Global.Type.STEEL,
	"rock": Global.Type.ROCK,
	"water": Global.Type.WATER,
	"none": Global.Type.NONE
}

const DAMAGE_TYPE_MAP: Dictionary = {
	"special": Global.DamageType.SPECIAL,
	"physical": Global.DamageType.PHYSICAL,
	"status": Global.DamageType.STATUS
}

const TARGET_MAP: Dictionary = {
	"specific-move": Global.Target.TARGET,
	"selected-pokemon-me-first": Global.Target.TARGET,
	"ally": Global.Target.ALL_ALLY,
	"users-field": Global.Target.USER_FIELD,
	"user-or-ally": Global.Target.USER_AND_ALLY,
	"opponents-field": Global.Target.OPPONENT_FIELD,
	"user": Global.Target.USER,
	"random-opponent": Global.Target.RANDOM_OPPONENT,
	"all-other-pokemon": Global.Target.ALL_OTHER,
	"selected-pokemon": Global.Target.TARGET,
	"all-opponents": Global.Target.ALL_OPPONENTS,
	"entire-field": Global.Target.ALL_FIELD,
	"user-and-allies": Global.Target.USER_AND_ALLY,
	"all-pokemon": Global.Target.ALL_FIELD,
	"all-allies": Global.Target.ALL_ALLY,
	"fainting-pokemon": Global.Target.FAINTING
}

const STAT_MAP: Dictionary = {
	"hp": Global.Stat.HEALTH,
	"defense": Global.Stat.DEFENSE,
	"special-defense": Global.Stat.SPECIAL_DEFENSE,
	"speed": Global.Stat.SPEED,
	"attack": Global.Stat.ATTACK,
	"special-attack": Global.Stat.SPECIAL_ATTACK
}

const AILMENT_MAP: Dictionary = {
	"none": Global.Ailment.NONE,
	"paralysis": Global.Ailment.PARALYSIS,
	"sleep": Global.Ailment.SLEEP,
	"freeze": Global.Ailment.FREEZE,
	"burn": Global.Ailment.BURN,
	"poison": Global.Ailment.POISON,
	"confusion": Global.Ailment.CONFUSION,
	"infatuation": Global.Ailment.INFATUATION,
	"trap": Global.Ailment.TRAP,
	"nightmare": Global.Ailment.NIGHTMARE,
	"torment": Global.Ailment.TORMENT,
	"disable": Global.Ailment.DISABLE,
	"yawn": Global.Ailment.YAWN,
	"heal-block": Global.Ailment.HEAL_BLOCK,
	"no-type-immunity": Global.Ailment.NO_TYPE_IMMUNITY,
	"leech-seed": Global.Ailment.LEECH_SEED,
	"embargo": Global.Ailment.EMBARGE,
	"perish-song": Global.Ailment.PERISH_SONG,
	"ingrain": Global.Ailment.INGRAIN,
	"silence": Global.Ailment.SILENCE,
	"tar-shot": Global.Ailment.TAR_SHOT,
	"unknown": Global.Ailment.RANDOM
}

# Loads and returns all data from a JSON file
static func load_json(path: String) -> Array:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error('Failed to open ' + path)
		return []
	var text: String = file.get_as_text()
	file.close()
	return JSON.parse_string(text)

# Extracts all info from all_pokemon_details.json
static func get_all_pokemon_details() -> Array:
	return load_json('res://Moves/all_pokemon_details.json')

# Extracts all info from filtered_move_details.json
static func get_filtered_move_details() -> Array:
	return load_json('res://Moves/filtered_move_details.json')

static func get_stat_changes(stat_changes: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for change in stat_changes:
		var stat_change: int = change.get('change', 0)
		var stat: Global.Stat = STAT_MAP.get(change['stat']['name'], Global.Stat.HEALTH)
		result.append({ "change": stat_change, "stat": stat })
	return result

static func null_replace_int(value) -> int:
	if value == null:
		return -1
	else:
		return value

static func null_replace_dict(value) -> Dictionary:
	if value == null:
		return {}
	else:
		return value

static func get_ailments(ailments: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	var effect: Global.Ailment = AILMENT_MAP.get(ailments['ailment']['name'], Global.Ailment.NONE)
	var chance: int = ailments['ailment_chance']
	result = { "ailment": effect, "ailment_chance": chance }
	return result

# Example usage: print all Pokémon names from all_pokemon_details.json
static func load_moves() -> void:
	var all_moves: Array = get_filtered_move_details()
	var id: int = 0
	for m in all_moves: 
		var move: Move = Move.new()
		move.id = id
		move.name = m['name']
		move.type = TYPE_MAP.get(m['type']['name'], Global.Type.NONE)
		move.damage_type = DAMAGE_TYPE_MAP.get(m['damage_class']['name'], Global.DamageType.SPECIAL)
		move.target = TARGET_MAP.get(m['target']['name'], Global.Target.TARGET)
		var meta: Dictionary = null_replace_dict(m['meta'])
		if !meta.is_empty():
			move.ailment = get_ailments(meta)
			move.crit_rate = meta['crit_rate']
			move.drain = meta['drain']
			move.flinch_chance = meta['flinch_chance']
			move.healing = meta['healing']
			move.max_hits = null_replace_int(meta['max_hits'])
			move.max_turns = null_replace_int(meta['max_turns'])
			move.min_hits = null_replace_int(meta['min_hits'])
			move.min_turns = null_replace_int(meta['min_turns'])
			move.stat_chance = meta['stat_chance']
		move.power = null_replace_int(m['power'])
		move.stat_changes = get_stat_changes(m['stat_changes'])
		move.priority = m['priority']
		move.accuracy = null_replace_int(m['accuracy'])
		move.pp = null_replace_int(m['pp'])
		move.completed = false
		var path: String = "res://Resources/Moves/" + move.name + ".tres"
		print_debug("saved")
		ResourceSaver.save(move, path)
		id += 1

static func load_pokemon() -> void:
	pass
