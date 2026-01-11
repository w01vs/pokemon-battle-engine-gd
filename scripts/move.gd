class_name Move extends Resource

@export var id: int
@export var name: String = ""
@export var power: int = 0
@export var accuracy: int = 0
@export var priority: int = 0
@export var pp: int = 0
@export var type: Global.Type = Global.Type.NONE
@export var target: Global.Target = Global.Target.TARGET
@export var ailment: Dictionary = {}
@export var damage_type: Global.DamageType = Global.DamageType.SPECIAL
@export var crit_rate: int = 0
@export var drain: int = 0
@export var flinch_chance: int = 0
@export var healing: int = 0
@export var max_hits: int = -1
@export var max_turns: int = -1
@export var min_hits: int = -1
@export var min_turns: int = -1
@export var stat_chance: int = 0
@export var stat_changes: Array = [] # Array[Dictionary] { Global.Stat: int } = 
@export var completed: bool = false
@export var unique_effect: bool = false
@export var move_type: Global.MoveType = Global.MoveType.DAMAGE
