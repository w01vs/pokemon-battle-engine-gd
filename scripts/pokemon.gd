class_name Pokemon extends Resource

@export var name: String

@export var _hp_stat: int
@export var _atk_stat: int
@export var _def_stat: int

var hp: int

@export var movepool: Array[Move]
@export var move1: Move
@export var move2: Move

@export var texture: Texture2D

@export var ability: Ability
