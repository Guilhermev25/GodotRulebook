@tool
class_name RulebookEditorIO

static var SAVED_RULEBOOKS_PATH := "res://addons/godot_rulebook/editor/saved_rulebooks/"
static var EDITOR_RULEBOOK := load("res://addons/godot_rulebook/editor/core/editor_rulebook.tscn")
static var EDITOR_RULE := load("res://addons/godot_rulebook/editor/core/editor_rule.tscn")
static var EDITOR_PREDICATE := load("res://addons/godot_rulebook/editor/core/editor_predicate.tscn")
static var EDITOR_PREMISE := load("res://addons/godot_rulebook/editor/core/editor_premise.tscn")


static func save_on_disk(editor_rulebook: EditorRulebook) -> void:
	var rulebook := Rulebook.new()
	editor_rulebook.save_info(rulebook)
	for editor_rule: EditorRule in editor_rulebook.get_rules():
		var rule := Rule.new()
		editor_rule.save_info(rule)
		add_node(rulebook, rule, rulebook)
		var condition = rule.condition
		add_node(rule, condition, rulebook)
		rulebook.rules.append(rule)
		for editor_predicate: EditorPredicate in editor_rule.get_predicates():
			var predicate := Predicate.new()
			editor_predicate.save_info(predicate)
			add_node(condition, predicate, rulebook)
			rule.condition.predicates.append(predicate)
			for editor_premise: EditorPremise in editor_predicate.get_premises():
				var premise := Premise.new()
				editor_premise.save_info(premise)
				add_node(predicate, premise, rulebook)
				predicate.premises.append(premise)
	
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(rulebook)
	if result == OK:
		var error = ResourceSaver.save(packed_scene, SAVED_RULEBOOKS_PATH + rulebook.name + ".tscn")
		if error != OK:
			push_error("An error occurred while saving the Rulebook to disk.")


static func add_node(parent: Node, child: Node, owner: Node) -> void:
	parent.add_child(child)
	child.owner = owner


static func load_all_from_disk() -> Array[EditorRulebook]:
	var rulebooks: Array[EditorRulebook]
	var dir := DirAccess.open(SAVED_RULEBOOKS_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var scene: PackedScene = ResourceLoader.load(SAVED_RULEBOOKS_PATH + file_name)
			var saved_rulebook: Rulebook = scene.instantiate()
			if saved_rulebook:
				rulebooks.append(build_editor_rulebook(saved_rulebook))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return rulebooks


static func build_editor_rulebook(rulebook: Rulebook) -> EditorRulebook:
	var editor_rulebook: EditorRulebook = EDITOR_RULEBOOK.instantiate()
	editor_rulebook.load_info(rulebook)
	for rule: Rule in rulebook.rules:
		var editor_rule: EditorRule = EDITOR_RULE.instantiate()
		editor_rulebook.add_rule(editor_rule)
		editor_rule.load_info(rule)
		for predicate: Predicate in rule.condition.predicates:
			var editor_predicate: EditorPredicate = EDITOR_PREDICATE.instantiate()
			editor_rule.add_predicate(editor_predicate)
			editor_predicate.load_info(predicate)
			for premise in predicate.premises:
				var editor_premise: EditorPremise = EDITOR_PREMISE.instantiate()
				editor_predicate.add_premise(editor_premise)
				editor_premise.load_info(premise)
	return editor_rulebook
