extends Control

@onready var label: RichTextLabel = $"RichTextLabel"
@onready var hp_display: RichTextLabel = $"hp"

@export var controller: BattleController
@export var _slot: BattleController.UI

var _max_hp: int = 0
var _hp: int = 0

func _ready() -> void:
	controller.pokemon_hp_changed.connect(_update_hp)

func _update_hp(hp: int, slot: BattleController.UI) -> void:
	if slot == _slot:
		_hp = hp
		hp_display.text = "%d / %d" % [_hp, _max_hp]
