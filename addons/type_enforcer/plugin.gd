@tool
extends EditorPlugin

var file_system: EditorFileSystem
var last_errors: Array[String] = []
var editor_interface: EditorInterface

var original_run_function: Callable
var my_custom_dock: Control

func _enter_tree() -> void:
	# Access the file system and check the scripts when the plugin is loaded
	file_system = get_editor_interface().get_resource_filesystem()
	check_all_scripts()
	# Optional: add a toolbar button
	add_tool_menu_item("Check Typed Scripts", _on_check_scripts)
	resource_saved.connect(_on_resource_saved)
	# This function is called when the plugin is enabled.
	# Create the main control for our dock.
	my_custom_dock = Control.new()
	my_custom_dock.name = "JSON Data"
	var button_container = VBoxContainer.new()
	button_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# Create a button and set its properties.
	
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
	# Remove toolbar item when the plugin is unloaded
	remove_tool_menu_item("Check Typed Scripts")
	# This function is called when the plugin is disabled.
	# It's important to clean up and remove the control from the editor.
	remove_control_from_docks(my_custom_dock)
	my_custom_dock.free()


func _on_resource_saved(res: Resource) -> void:
	if res is GDScript and not res.resource_path.begins_with("res://addons") and not res.resource_path.begins_with("res://example"):
		_check_script(res)


func _on_check_scripts() -> void:
	# Manually trigger script check (can be used from the tool menu item)
	check_all_scripts()


func check_all_scripts() -> void:
	# Start checking the scripts in the project
	var scripts = _get_all_gd_scripts("res://")  # adjust path as needed
	for script_path in scripts:
		var script: Resource = load(script_path)
		if script is GDScript:
			_check_script(script)


func _get_all_gd_scripts(folder: String) -> Array:
	# Recursively get all .gd scripts under the specified folder
	var result: Array = []
	var dir: DirAccess = DirAccess.open(folder)
	if not dir:
		return result

	dir.list_dir_begin()
	var file: String = dir.get_next()
	while file != "":
		var full_path: String = folder.path_join(file)
		if dir.current_is_dir():
			if full_path.begins_with("res://addons") or full_path.begins_with("res://example"):  # Skip addon directories
				file = dir.get_next()
				continue
			# Recursively process subdirectories
			result += _get_all_gd_scripts(full_path)
		elif file.ends_with(".gd"):  # Only consider .gd files
			result.append(full_path)
		file = dir.get_next()
	dir.list_dir_end()
	return result


func _check_script(script: GDScript) -> void:
	var code: String = script.source_code
	var issues: Array = []
	var lines: PackedStringArray = code.split("\n")

	var var_regex: RegEx = RegEx.new()
	var_regex.compile(r"^(?:@[\w\s]+)*\s*(var|const)\s+\w+")

	var i := 0
	while i < lines.size():
		var line: String = lines[i].strip_edges()
		var line_number: int = i + 1

		# Skip empty lines and comments
		if line == "" or line.begins_with("#"):
			i += 1
			continue

		# Check for untyped functions (including multi-line headers)
		if line.begins_with("func "):
			var func_lines := [line]
			while not line.contains(")") and i + 1 < lines.size():
				i += 1
				line = lines[i].strip_edges()
				func_lines.append(line)

			var full_signature := " ".join(func_lines)
			var param_list_start := full_signature.find("(")
			var param_list_end := full_signature.find(")")
			if param_list_start != -1 and param_list_end > param_list_start:
				var params := full_signature.substr(param_list_start + 1, param_list_end - param_list_start - 1).split(",", false)
				for param in params:
					param = param.strip_edges()
					if param != "" and ":" not in param:
						issues.append("Line %d: Untyped function parameter: %s" % [line_number, param])

			if (":" not in full_signature or "->" not in full_signature):
				issues.append("Line %d: Untyped function: %s" % [line_number, full_signature])
			i += 1
			continue

		# Check for variable/constant declarations
		if var_regex.search(line):
			var type_str: String = ""
			var type_match: int = line.find(":")
			var equals_match: int = line.find("=")
			if type_match > -1 and equals_match > type_match:
				type_str = line.substr(type_match + 1, equals_match - type_match - 1).strip_edges()
			elif type_match < 0:
				issues.append("Line %d: Missing type: %s" % [line_number, line])
				i += 1
				continue

			var after_colon: String = line.substr(type_match + 1).strip_edges()
			if after_colon.begins_with("=") or after_colon == "":
				issues.append("Line %d: Missing type: %s" % [line_number, line])
				i += 1
				continue

			if line.contains(":="):
				issues.append("Line %d: Using disallowed type inference: %s" % [line_number, line])
				i += 1
				continue

		i += 1

	if issues.size() > 0:
		push_warning("Typing issues in %s:\n  %s" % [script.resource_path, "\n  ".join(issues)])
