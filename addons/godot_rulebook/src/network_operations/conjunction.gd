class_name Conjunction
extends Object

signal forward_add(instance: Monitorable)
signal forward_remove(instance: Monitorable)

var premise: SimplePremise
var local_memory: Array[Monitorable] 


func add_to_local_memory(instance: Monitorable):
	local_memory.append(instance)
	if premise.get_evaluation(instance):
		forward_add.emit(instance)


func remove_from_local_memory(instance: Monitorable):
	# NOTE: Maybe implement it using a Dictionary for faster erase?
	local_memory.erase(instance)
	if premise.get_evaluation(instance):
		forward_remove.emit(instance)


func only_propagate_remove(instance: Monitorable):
	forward_remove.emit(instance)


func only_propagate_add(instance: Monitorable):
	forward_add.emit(instance)
