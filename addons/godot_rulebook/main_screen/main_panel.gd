@tool
extends PanelContainer

const RULEBOOK_TAB := preload("res://addons/godot_rulebook/main_screen/components/rulebook_tab.tscn")
var suffix: int = 1

@export var resource: Resource

func get_rulebooks() -> Array[Control]:
	var result: Array[Control]
	for rulebook: Control in %TabContainer.get_children():
		if rulebook.name != "+ Rulebook":
			result.append(rulebook)
	return result


func load_rulebook(rulebook: Control, custom_position: int = 0) -> void:
	%TabContainer.add_child(rulebook)
	%TabContainer.move_child(rulebook, custom_position)


func create_rulebook() -> void:
	var new_rulebook = RULEBOOK_TAB.instantiate()
	new_rulebook.name = "My Rulebook " + str(suffix)
	suffix += 1
	load_rulebook(new_rulebook, %"+ Rulebook".get_index())


func _on_tab_container_tab_clicked(tab: int):
	if tab == %TabContainer.get_tab_idx_from_control(%"+ Rulebook"):
		create_rulebook()
