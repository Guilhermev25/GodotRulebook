class_name SimplePremise
extends NetworkPremise

signal add(instance: Monitorable)
signal remove(instance: Monitorable)
var monitored_instances: Dictionary # Monitorable: bool


func _attribute_changed(instance: Monitorable) -> void:
	var evaluation: bool = expression.execute([instance])
	if evaluation != monitored_instances[instance]:
		add.emit(instance) if evaluation else remove.emit(instance)
		monitored_instances[instance] = evaluation


func _instance_deleted(instance: Monitorable) -> void:
	monitored_instances.erase(instance)
	remove.emit(instance)


func get_evaluation(instance: Monitorable) -> bool:
	return monitored_instances[instance]
