class_name VariablePremise
extends RulePremise

signal update(instance: Monitorable)


func _property_changed(instance: Monitorable) -> void:
	update.emit(instance)


func _instance_deleted(instance: Monitorable) -> void:
	pass
