class_name Rulebook
extends Node

var premises: Dictionary
var conflict_set: Array[RulePremise] 


func add_monitorable_instance(instance: Monitorable) -> void:
	var instance_class: String = instance.get_script().get_global_name()
	var class_premises: Array[RulePremise] = premises[instance_class]
	for premise in class_premises:
		premise.connect_instance(instance)


func add_rule(rule: Rule) -> void:
	pass


func build_network() -> void:
	pass


func remove_from_conflict_set(rule: Rule) -> void:
	# NOTE: Maybe implement it using a Dictionary for faster erase?
	conflict_set.erase(rule) 


func add_to_conflict_set(rule: Rule) -> void:
	conflict_set.append(rule)
