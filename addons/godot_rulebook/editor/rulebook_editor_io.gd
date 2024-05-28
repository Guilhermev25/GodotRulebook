extends Node
class_name RulebookEditorIO

static var SAVED_RULEBOOKS_PATH := "res://addons/godot_rulebook/editor/saved_rulebooks/"
static var EDITOR_RULEBOOK := load("res://addons/godot_rulebook/editor/components/editor_rulebook.tscn")
static var EDITOR_RULE := load("res://addons/godot_rulebook/editor/components/editor_rule.tscn")
static var EDITOR_MONITORABLE := load("res://addons/godot_rulebook/editor/components/editor_monitorable.tscn")
static var EDITOR_PREMISE := load("res://addons/godot_rulebook/editor/components/editor_premise.tscn")


func save_on_disk(rulebook: Control) -> void:
	pass


func load_all_from_disk() -> Array[Control]:
	return []
