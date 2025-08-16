class_name BattleController extends Node

@onready var player_slot: Control = $"../UI/PlayerSlot"
@onready var trainer_slot: Control = $"../UI/TrainerSlot"



func start(player: Trainer, opponent: Trainer) -> void:
	# throw out pokemon player
	player_slot.rect.texture = player.get_active_pokemon().texture
	player_slot.label.text = player.get_active_pokemon().name
	player_slot.set_max_hp(player.get_active_pokemon().hp)
	player_slot.set_hp(player.get_active_pokemon().hp)
	# throw out pokemon opponent
	trainer_slot.rect.texture = opponent.get_active_pokemon().texture
	trainer_slot.label.text = opponent.get_active_pokemon().name
	trainer_slot.set_max_hp(opponent.get_active_pokemon().hp)
	trainer_slot.set_hp(opponent.get_active_pokemon().hp)
	# move to turnstart
