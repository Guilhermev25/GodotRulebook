@tool
extends EditorPlugin

const MAIN_PANEL := preload("res://addons/godot_rulebook/main_screen/main_panel.tscn")
const ICON := preload("res://addons/godot_rulebook/main_screen/icon.svg")
const AUTOLOAD_NAME := "RulebooksManager"
const SAVED_RULEBOOKS_PATH := "res://addons/godot_rulebook/saved_rulebooks/"

var main_panel_instance: Node

# Initialization of the plugin.
func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/godot_rulebook/src/manager.gd")
	main_panel_instance = MAIN_PANEL.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	load_rulebooks_from_disk()
	# Hide the main panel. Very much required.
	_make_visible(false)


func load_rulebooks_from_disk() -> void:
	var dir = DirAccess.open(SAVED_RULEBOOKS_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var scene: PackedScene = ResourceLoader.load(SAVED_RULEBOOKS_PATH + file_name)
			var result = scene.instantiate()
			if result:
				main_panel_instance.load_rulebook(result)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

# Clean-up of the plugin.
func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible


func _save_external_data() -> void:
	for rulebook: Control in main_panel_instance.get_rulebooks():
		print(rulebook.get_tree_string_pretty())
		for child: Control in rulebook.get_children():
			child.propagate_call("set_owner", [rulebook])
			child.propagate_call("et_scene_file_path", [""])
		
		var scene: PackedScene = PackedScene.new()
		var result = scene.pack(rulebook)
		if result == OK:
			var error = ResourceSaver.save(scene, SAVED_RULEBOOKS_PATH + rulebook.name + ".tscn")
			if error != OK:
				push_error("An error occurred while saving the Rulebook to disk.")


func _get_plugin_name() -> String:
	return "Rulebook"


func _get_plugin_icon() -> Texture2D:
	return ICON
