@tool
class_name EditorRule
extends PanelContainer


func _ready():
	update_rule_type_list()


func update_rule_type_list() -> void:
	var selected_text: String = ""
	if not %RuleTypeList.get_selected_items().is_empty():
		var selected_idx: int = %RuleTypeList.get_selected_items()[0]
		selected_text = %RuleTypeList.get_item_text(selected_idx)
	
	%RuleTypeList.clear()
	for type: String in Rule.RuleType.keys():
		%RuleTypeList.add_item(type)
	
	if selected_text != "":
		for index in range(%RuleTypeList.item_count):
			if %RuleTypeList.get_item_text(index) == selected_text:
				%RuleTypeList.select(index)
				break


func _on_fold_rule_button_toggled(toggled_on: bool):
	%ContentsMargin.visible = toggled_on


func _on_add_predicate_pressed():
	add_predicate(RulebookEditorIO.EDITOR_PREDICATE.instantiate())


func add_predicate(predicate: EditorPredicate):
	%Predicates.add_child(predicate)
	%Predicates.move_child(predicate, %AddPredicateSection.get_index())


func get_predicates() -> Array[EditorPredicate]:
	var result: Array[EditorPredicate]
	for child in %Predicates.get_children():
		if child is EditorPredicate:
			result.append(child)
	return result


func _on_delete_rule_pressed():
	queue_free()


func save_info(rule: Rule):
	rule.name = %RuleName.editable_name
	rule.type = %RuleTypeList.get_selected_items()[0]
	rule.resolution_path = %ResolutionPath.text


func load_info(rule: Rule):
	%RuleName.rename(rule.name)
	update_rule_type_list()
	%RuleTypeList.select(rule.type)
	%ResolutionPath._on_text_submitted(rule.resolution_path)


