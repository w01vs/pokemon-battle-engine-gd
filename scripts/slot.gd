extends Control

@onready var _label: RichTextLabel = $"RichTextLabel"
@onready var _hp_display: RichTextLabel = $"hp"

@export var _controller: BattleController
@export var _slot: BattleController.Side

var _max_hp: int = 0
var _hp: int = 0

func _ready() -> void:
	_controller.pokemon_hp_changed.connect(_update_hp)
	_controller.pokemon_swap.connect(_swap_pokemon)

func _swap_pokemon(pokemon: Pokemon, slot: BattleController.Side) -> void:
	if slot == _slot:
		_label.text = pokemon.name
		_hp_display.text = str(pokemon.hp)

func _update_hp(hp: int, slot: BattleController.Side) -> void:
	if slot == _slot:
		_hp = hp
		_hp_display.text = "%d / %d" % [_hp, _max_hp]
