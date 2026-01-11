extends Node

@onready var display: RichTextLabel = $"../display"

var _trainer = preload("res://resources/test_trainer.tres").duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
var _player = preload("res://resources/player.tres").duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
@onready var battle_controller: BattleController = $BattleController

func _ready() -> void:
	for trainer in [_trainer, _player]:
		for pokemon in trainer.team:
			pokemon.hp = pokemon._hp_stat
			pokemon.max_hp = pokemon.hp
			pokemon.speed = pokemon._speed_stat
			pokemon.moves[0].damage_type = Global.DamageType.SPECIAL
	#ResourceGenerator.update_moves_jsontoresource()
	battle_controller.initialise(_player, _trainer)
	battle_controller.update_text.connect(_update_display)
	

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("start") and battle_controller._state == BattleController.BattleState.BATTLE_START:
		battle_controller.start(_player, _trainer)
		display.text = "battling...."


func _update_display(text: String) -> void:
	display.text = text
