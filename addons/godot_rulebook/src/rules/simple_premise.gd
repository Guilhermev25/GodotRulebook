class_name SimplePremise
extends RulePremise

signal add(instance: Monitorable)
signal remove(instance: Monitorable)


func _property_changed(instance: Monitorable) -> void:
	var result: bool = evaluate(instance)
	if result != monitored_instances[instance]:
		add.emit(instance) if result else remove.emit(instance)


func evaluate(instance: Monitorable) -> bool:
	return false
