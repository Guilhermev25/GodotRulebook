class_name VariablePremise
extends RulePremise

signal update(instance: Monitorable)
signal add(instance: Monitorable)
signal remove(instance: Monitorable)


func _property_changed(instance: Monitorable) -> void:
	update.emit(instance)


func _add_instance(instance: Monitorable) -> void:
	add.emit(instance)


func _instance_deleted(instance: Monitorable) -> void:
	remove.emit(instance)
