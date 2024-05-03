@tool
extends Node

var rulebooks: Dictionary


func get_all_rulebooks() -> Array[Rulebook]:
	var list: Array[Rulebook]
	for key in rulebooks:
		list.append(rulebooks[key])
	return list


func get_rulebook(rulebook_name: String) -> Rulebook:
	return rulebooks[rulebook_name]
