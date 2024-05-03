class_name Binding
extends Object

var local_memory: Array[Monitorable] 


func add_to_local_memory(instance: Monitorable):
	local_memory.append(instance)
	# ...


func remove_from_local_memory(instance: Monitorable):
	# NOTE: Maybe implement it using a Dictionary for faster erase?
	local_memory.erase(instance)
	# ...
