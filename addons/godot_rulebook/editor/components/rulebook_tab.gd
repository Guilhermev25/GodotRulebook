@tool
extends PanelContainer

const FOLDABLE_RULE := preload("res://addons/godot_rulebook/editor/components/foldable_rule.tscn")


func _on_rulebook_name_text_changed(new_text: String):
	name = new_text


func _on_add_rule_pressed():
	var new_rule: Control = FOLDABLE_RULE.instantiate()
	%Rules.add_child(new_rule)
	%Rules.move_child(new_rule, %AddRule.get_index())


func _on_delete_rulebook_pressed():
	queue_free()
