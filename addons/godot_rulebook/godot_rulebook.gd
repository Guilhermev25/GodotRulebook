@tool
extends EditorPlugin

const MAIN_PANEL = preload("res://addons/godot_rulebook/main_screen/main_panel.tscn")
const ICON = preload("res://addons/godot_rulebook/main_screen/icon.svg")

var main_panel_instance

# Initialization of the plugin.
func _enter_tree():
	main_panel_instance = MAIN_PANEL.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)

# Clean-up of the plugin.
func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "Rulebook"


func _get_plugin_icon():
	return ICON
