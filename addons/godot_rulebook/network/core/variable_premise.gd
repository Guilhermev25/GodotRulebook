class_name VariablePremise
extends NetworkPremise

signal update(instance: Monitorable)
signal created(instance: Monitorable)
signal deleted(instance: Monitorable)


func _attribute_changed(instance: Monitorable) -> void:
	update.emit(instance)


func _add_instance(instance: Monitorable) -> void:
	created.emit(instance)


func _delete_instance(instance: Monitorable) -> void:
	deleted.emit(instance)
