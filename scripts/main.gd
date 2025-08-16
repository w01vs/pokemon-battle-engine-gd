extends Node2D

@onready var display: RichTextLabel = $"UI/display"
@onready var BSM: BattleStateMachine = $"BattleController/BattleStateMachine"

var trainer = preload("res://resources/test_trainer.tres")
var player = preload("res://resources/player.tres")
@onready var battle_controller: BattleController = $"BattleController"

func _ready() -> void:
	for team in [trainer, player]:
		for pokemon in team.team:
			pokemon.hp = pokemon._hp_stat

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("start") and !BSM.is_processing():
		battle_controller.start(player, trainer)
		display.text = "battling...."
