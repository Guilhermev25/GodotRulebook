class_name Assignment
extends Node

var local_memory: Array[Monitorable]


func add_to_local_memory(instance: Monitorable) -> void:
	local_memory.append(instance)
	# ...


func remove_from_local_memory(instance: Monitorable) -> void:
	# NOTE: Maybe implement it using a Dictionary for faster erase?
	local_memory.erase(instance)
	# ...


func update_instance(instance: Monitorable) -> void:
	remove_from_local_memory(instance)
	add_to_local_memory(instance)
