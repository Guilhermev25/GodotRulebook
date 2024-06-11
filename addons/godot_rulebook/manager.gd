@tool
extends Node

var rulebook_names: Array[String]
var rulebooks: Dictionary # String: CompiledRulebook


func _init() -> void:
	if not Engine.is_editor_hint():
		for rulebook: Rulebook in RulebookIO.load_all():
			rulebooks[rulebook.name] = NetworkBuilder.compile_rulebook(rulebook)


func add_hint(_name: String) -> void:
	rulebook_names.append(_name)


func remove_hint(_name: String) -> void:
	rulebook_names.erase(_name)


func get_rulebook_hints() -> String:
	var hints := ""
	for key: String in rulebook_names:
		hints += key + ","
	return hints


func get_rulebook(rulebook_name: String) -> CompiledRulebook:
	return rulebooks[rulebook_name]
