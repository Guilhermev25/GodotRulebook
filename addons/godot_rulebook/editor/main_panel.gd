@tool
extends PanelContainer

signal make_floating
var suffix: int = 1


func get_rulebooks() -> Array[Control]:
	var result: Array[Control]
	for rulebook: Control in %TabContainer.get_children():
		if rulebook.name != "+ Rulebook":
			result.append(rulebook)
	return result


func add_rulebook(rulebook: Control, custom_position: int = 0) -> void:
	%TabContainer.add_child(rulebook)
	%TabContainer.move_child(rulebook, custom_position)


func create_rulebook() -> void:
	var new_rulebook = RulebookEditorIO.EDITOR_RULEBOOK.instantiate()
	new_rulebook.name = "Rulebook " + str(suffix)
	suffix += 1
	add_rulebook(new_rulebook, %"+ Rulebook".get_index())


func _on_tab_container_tab_clicked(tab: int):
	if tab == %TabContainer.get_tab_idx_from_control(%"+ Rulebook"):
		create_rulebook()


func _on_make_floating_pressed():
	%MakeFloating.visible = false
	make_floating.emit()


func undo_floating_panel():
	%MakeFloating.visible = true
