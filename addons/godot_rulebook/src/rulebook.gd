class_name Rulebook
extends Node

var rulebook_name: String
var premises: Dictionary


func add_monitorable_instance(instance: Monitorable):
	var instance_class: String = instance.get_class()
	var class_premises: Array[RulePremise] = premises[instance_class]
	for premise in class_premises:
		premise.connect_instance(instance)
