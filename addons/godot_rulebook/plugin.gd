@tool
extends EditorPlugin

const MAIN_PANEL := preload("res://addons/godot_rulebook/main_screen/main_panel.tscn")
const ICON := preload("res://addons/godot_rulebook/main_screen/icon.svg")
const AUTOLOAD_NAME := "RulebooksManager"

var main_panel_instance: Node

# Initialization of the plugin.
func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/godot_rulebook/src/manager.gd")
	main_panel_instance = MAIN_PANEL.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)

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


func _get_plugin_name() -> String:
	return "Rulebook"


func _get_plugin_icon() -> Texture2D:
	return ICON
