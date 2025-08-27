class_name Move extends Resource

@export var id: int
@export var name: String
@export var power: int
@export var accuracy: int
@export var priority: int = 0
@export var pp: int
@export var type: Global.Type
@export var target: Global.Target
@export var ailment: Dictionary
@export var damage_type: Global.DamageType
@export var crit_rate: int
@export var drain: int
@export var flinch_chance: int
@export var healing: int
@export var max_hits: int
@export var max_turns: int
@export var min_hits: int
@export var min_turns: int
@export var stat_chance: int
@export var stat_changes: Array # Array[Dictionary] { Global.Stat: int }
@export var completed: bool
@export var unique_effect: bool
@export var move_type: Global.MoveType
