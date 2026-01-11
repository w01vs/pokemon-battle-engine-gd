extends Control

@onready var _label: RichTextLabel = $"RichTextLabel"
@onready var _hp_display: RichTextLabel = $"hp"

@export var _controller: BattleController
@export var _side: BattleController.Side

var _id: int

var _max_hp: int = 0

func _ready() -> void:
	_controller.pokemon_hp_changed.connect(_update_hp)
	_controller.pokemon_swap.connect(_swap_pokemon)
	_controller.pokemon_start.connect(setup)

func setup(id: int, pokemon: Pokemon, side: BattleController.Side) -> void:
	if side == _side:
		_id = id
		_label.text = pokemon.name
		_max_hp = pokemon.max_hp
		_update_hp(id, pokemon.hp)
	
func _swap_pokemon(id: int, pokemon: Pokemon) -> void:
	if _id == id:
		setup(id, pokemon, _side)

func _update_hp(id: int, hp: int) -> void:
	if id == _id:
		_hp_display.text = "%d / %d" % [hp, _max_hp]
