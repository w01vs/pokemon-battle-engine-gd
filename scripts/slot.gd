extends Control

@onready var label: RichTextLabel = $"RichTextLabel"
@onready var rect: TextureRect = $"TextureRect"
@onready var hp: RichTextLabel = $"hp"

var _max_hp: int = 0
var _hp: int = 0

func set_max_hp(max_hp: int) -> void:
	_max_hp = max_hp
	_update_hp()

func set_hp(new_hp: int) -> void:
	_hp = new_hp
	_update_hp()


func _update_hp() -> void:
	hp.text = "%d / %d" % [_hp, _max_hp]
