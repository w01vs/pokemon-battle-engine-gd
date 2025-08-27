@tool
extends EditorPlugin

var my_custom_dock: Control

func _enter_tree() -> void:
	my_custom_dock = Control.new()
	my_custom_dock.name = "JSON Data"
	var button_container = VBoxContainer.new()
	button_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var json_read_moves = Button.new()
	json_read_moves.text = "Load moves from JSON"
	json_read_moves.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var json_write_moves = Button.new()
	json_write_moves.text = "Write moves to JSON"
	json_write_moves.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var json_read_moves_pokeapi = Button.new()
	json_read_moves_pokeapi.text = "Load moves from PokeAPI JSON"
	json_read_moves_pokeapi.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	json_read_moves_pokeapi.disabled = true

	json_write_moves.connect("pressed", Callable(self, "_on_json_write_moves"))
	json_read_moves.connect("pressed", Callable(self, "_on_json_read_moves"))
	json_read_moves_pokeapi.connect("pressed", Callable(self, "_on_json_read_pokeapi"))
	
	button_container.add_child(json_write_moves)
	button_container.add_child(json_read_moves)
	button_container.add_child(json_read_moves_pokeapi)
	
	my_custom_dock.add_child(button_container)

	add_control_to_dock(DOCK_SLOT_LEFT_BR, my_custom_dock)

func _on_json_read_moves() -> void:
	ResourceGenerator.update_moves_jsontoresource()
	print("Finished loading move data from Godot JSON")

func _on_json_read_pokeapi() -> void:
	ResourceGenerator.load_moves_pokeapi()
	print("Finished loading move data from PokeAPI JSON")

func _on_json_write_moves():
	ResourceGenerator.update_move_resourcetojson()
	print("Finished storing move data in Godot JSON")
	
func _exit_tree() -> void:
	remove_control_from_docks(my_custom_dock)
	my_custom_dock.free()
