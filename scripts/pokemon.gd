class_name Pokemon extends Resource

@export var name: String

@warning_ignore("unused_private_class_variable")
@export var _hp_stat: int
@warning_ignore("unused_private_class_variable")
@export var _atk_stat: int
@warning_ignore("unused_private_class_variable")
@export var _def_stat: int
@warning_ignore("unused_private_class_variable")
@export var _speed_stat: int
@warning_ignore("unused_private_class_variable")
@export var _primary_type: Global.Type
@warning_ignore("unused_private_class_variable")
@export var _secondary_type: Global.Type

var hp: int
var max_hp: int

var speed: int

@export var movepool: Array[Move]
@export var moves: Array[Move]

@export var texture: Texture2D

@export var ability: Ability
