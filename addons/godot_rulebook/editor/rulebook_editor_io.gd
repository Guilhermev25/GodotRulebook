@tool
class_name RulebookEditorIO
extends RulebookIO

static var EDITOR_RULEBOOK := load("res://addons/godot_rulebook/editor/core/editor_rulebook.tscn")
static var EDITOR_RULE := load("res://addons/godot_rulebook/editor/core/editor_rule.tscn")
static var EDITOR_PREDICATE := load("res://addons/godot_rulebook/editor/core/editor_predicate.tscn")
static var EDITOR_PREMISE := load("res://addons/godot_rulebook/editor/core/editor_premise.tscn")


static func save_on_disk(editor_rulebook: EditorRulebook) -> void:
	var rulebook := get_savable_rulebook(editor_rulebook)
	save(rulebook)


static func get_savable_rulebook(editor_rulebook: EditorRulebook) -> Rulebook:
	var rulebook := Rulebook.new()
	editor_rulebook.save_info(rulebook)
	for editor_rule in editor_rulebook.get_rules():
		var rule := Rule.new()
		editor_rule.save_info(rule)
		add_node(rulebook, rule, rulebook)
		var condition = rule.condition
		add_node(rule, condition, rulebook)
		rulebook.rules.append(rule)
		for editor_predicate in editor_rule.get_predicates():
			var predicate := Predicate.new()
			editor_predicate.save_info(predicate)
			add_node(condition, predicate, rulebook)
			rule.condition.predicates.append(predicate)
			for editor_premise in editor_predicate.get_premises():
				var premise := Premise.new()
				editor_premise.save_info(premise)
				add_node(predicate, premise, rulebook)
				predicate.premises.append(premise)
	return rulebook


static func add_node(parent: Node, child: Node, owner: Node) -> void:
	parent.add_child(child)
	child.owner = owner


static func load_all_saved() -> Array[EditorRulebook]:
	var result: Array[EditorRulebook]
	for rulebook in load_all():
		var editor_rulebook := build_editor_rulebook(rulebook)
		result.append(editor_rulebook)
	return result


static func build_editor_rulebook(rulebook: Rulebook) -> EditorRulebook:
	var editor_rulebook: EditorRulebook = EDITOR_RULEBOOK.instantiate()
	editor_rulebook.load_info(rulebook)
	for rule in rulebook.rules:
		var editor_rule: EditorRule = EDITOR_RULE.instantiate()
		editor_rulebook.add_rule(editor_rule)
		editor_rule.load_info(rule)
		for predicate in rule.condition.predicates:
			var editor_predicate: EditorPredicate = EDITOR_PREDICATE.instantiate()
			editor_rule.add_predicate(editor_predicate)
			editor_predicate.load_info(predicate)
			for premise in predicate.premises:
				var editor_premise: EditorPremise = EDITOR_PREMISE.instantiate()
				editor_predicate.add_premise(editor_premise)
				editor_premise.load_info(premise)
	return editor_rulebook
