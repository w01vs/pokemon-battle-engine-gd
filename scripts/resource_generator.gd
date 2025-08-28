@tool
class_name ResourceGenerator extends Node

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

const MOVE_TYPE_MAP: Dictionary = {
		"damage": Global.MoveType.DAMAGE,
		"ailment": Global.MoveType.AILMENT,
		"net-good-stats": Global.MoveType.STAT,
		"heal": Global.MoveType.HEAL,
		"damage+ailment": Global.MoveType.DAMAGE_AILMENT,
		"swagger": Global.MoveType.SWAGGER,
		"damage+lower": Global.MoveType.DAMAGE_LOWER,
		"damage+raise": Global.MoveType.DAMAGE_RAISE,
		"damage+heal": Global.MoveType.DAMAGE_DRAIN,
		"ohko": Global.MoveType.OHKO,
		"whole-field-effect": Global.MoveType.ALL_FIELD,
		"field-effect": Global.MoveType.FIELD,
		"unique": Global.MoveType.UNIQUE,
		"force-switch": Global.MoveType.SWITCH
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
	"special-attack": Global.Stat.SPECIAL_ATTACK,
	"accuracy": Global.Stat.ACCURACY,
	"evasiveness": Global.Stat.EVASIVENESS 
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
	"embargo": Global.Ailment.EMBARGO,
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

static func load_moves_pokeapi() -> void:
	var all_moves: Array = load_json('res://JSON/filtered_move_details.json')
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
			move.move_type = MOVE_TYPE_MAP.get(meta['category']['name'])
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
		ResourceSaver.save(move, path)
		id += 1

static func save_to_json(file_path: String, data_array: Array) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		print("Error: Could not open file.")
		return

	# JSON.stringify can handle both dictionaries and arrays.
	var json_string: String = JSON.stringify(data_array, "\t")
	file.store_string(json_string)
	file.close()

static func update_move_resourcetojson() -> void:
	var dir: DirAccess = DirAccess.open("res://resources/Moves")
	var arr: Array
	if dir:
		dir.list_dir_begin()
		var filename: String = dir.get_next()
		while filename != "":
			if filename.ends_with(".tres"):
				var res: Resource = ResourceLoader.load("res://resources/Moves/" + filename)
				if res:
					var dict: Dictionary
					dict["id"] = res.id
					dict["name"] = res.name
					dict["power"] = res.power
					dict["accuracy"] = res.accuracy
					dict["priority"] = res.priority
					dict["pp"] = res.pp
					dict["type"] = res.type
					dict["target"] = res.target
					dict["ailment"] = res.ailment
					dict["damage_type"] = res.damage_type
					dict["crit_rate"] = res.crit_rate
					dict["drain"] = res.drain
					dict["flinch_chance"] = res.flinch_chance
					dict["healing"] = res.healing
					dict["max_hits"] = res.max_hits
					dict["max_turns"] = res.max_turns
					dict["min_hits"] = res.min_hits
					dict["min_turns"] = res.min_turns
					dict["stat_chance"] = res.stat_chance
					dict["stat_changes"] = res.stat_changes
					dict["completed"] = res.completed
					dict["unique_effect"] = res.unique_effect
					dict["move_type"] = res.move_type
					arr.append(dict.duplicate(true))
			filename = dir.get_next()
		save_to_json("res://JSON/updated_moves.json", arr)

static func update_moves_jsontoresource() -> void:
	var arr: Array= load_json("res://JSON/updated_moves.json")
	empty_directory("res://resources/Moves")
	if arr:
		for dict in arr:
			var move: Move = Move.new()
			move.id = dict["id"]
			move.name = dict["name"]
			move.power = dict["power"]
			move.accuracy = dict["accuracy"]
			move.priority = dict["priority"]
			move.pp = dict["pp"]
			move.type = dict["type"]
			move.target = dict["target"]
			move.ailment = dict["ailment"]
			move.damage_type = dict["damage_type"]
			move.crit_rate = dict["crit_rate"]
			move.drain = dict["drain"]
			move.flinch_chance = dict["flinch_chance"]
			move.healing = dict["healing"]
			move.max_hits = dict["max_hits"]
			move.max_turns = dict["max_turns"]
			move.min_hits = dict["min_hits"]
			move.min_turns = dict["min_turns"]
			move.stat_chance = dict["stat_chance"]
			move.stat_changes = dict["stat_changes"]
			move.completed = dict["completed"]
			move.unique_effect = dict["unique_effect"]
			move.move_type = dict["move_type"]
			var err: Error = ResourceSaver.save(move, "res://resources/Moves/" + move.name + ".tres", ResourceSaver.FLAG_CHANGE_PATH)
			if err != 0:
				print(err)

static func empty_directory(path: String) -> void:
	var dir_access: DirAccess = DirAccess.open(path)
	if dir_access == null:
		printerr("Error: Could not open directory at path: ", path)
		return

	dir_access.list_dir_begin()
	var filename: String = dir_access.get_next()

	while filename != "":
		if dir_access.current_is_dir():
			# Skip the "." and ".." directories to avoid infinite loops.
			if filename != "." and filename != "..":
				# Recursively empty the subdirectory.
				empty_directory(path.path_join(filename))
				# Now that the subdirectory is empty, remove it.
				dir_access.remove(path.path_join(filename))
		else:
			# Remove files directly.
			dir_access.remove(path.path_join(filename))
		
		filename = dir_access.get_next()

static func load_pokemon() -> void:
	pass
