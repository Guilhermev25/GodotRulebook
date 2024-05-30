@tool
class_name RulebookEditorIO

static var SAVED_RULEBOOKS_PATH := "res://addons/godot_rulebook/editor/saved_rulebooks/"
static var EDITOR_RULEBOOK := load("res://addons/godot_rulebook/editor/core/editor_rulebook.tscn")
static var EDITOR_RULE := load("res://addons/godot_rulebook/editor/core/editor_rule.tscn")
static var EDITOR_MONITORABLE := load("res://addons/godot_rulebook/editor/core/editor_monitorable.tscn")
static var EDITOR_PREMISE := load("res://addons/godot_rulebook/editor/core/editor_premise.tscn")


static func save_on_disk(rulebook: Control) -> void:
	pass


static func load_all_from_disk() -> Array[Control]:
	return []
