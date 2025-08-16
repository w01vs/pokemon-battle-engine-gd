class_name BattleStateMachine extends Node

var active_pokemon: Array[Pokemon] = []

var current_state: BattleState
@onready var TurnStartState: BattleState = $"TurnStart"

func _ready() -> void:
	set_process(false)

func start(pokemon: Array[Pokemon]) -> void:
	set_process(true)
	change_state(TurnStartState)


func change_state(state: BattleState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = state
	current_state.enter()



func _process(delta: float) -> void:
	current_state.update(delta, {"on_field": active_pokemon})
