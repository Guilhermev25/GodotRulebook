class_name VariablePremise
extends NetworkPremise

signal update(instance: Monitorable)
signal add(instance: Monitorable)
signal remove(instance: Monitorable)


func _attribute_changed(instance: Monitorable) -> void:
	update.emit(instance)


func _add_instance(instance: Monitorable) -> void:
	add.emit(instance)


func _instance_deleted(instance: Monitorable) -> void:
	remove.emit(instance)
