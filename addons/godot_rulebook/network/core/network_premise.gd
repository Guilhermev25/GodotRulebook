class_name NetworkPremise
extends Premise


func connect_instance(instance: Monitorable) -> void:
	connect_attr_signal(attribute, instance)
	if operand_type == OperandType.ATTRIBUTE:
		connect_attr_signal(operand, instance)
	_add_instance(instance)
	instance.deleted.connect(_delete_instance)


func connect_attr_signal(attribute: String, instance: Monitorable):
	var signal_name := attribute + Monitorable.CHANGED_SUFFIX
	if instance.has_signal(signal_name):
		instance.connect(signal_name, _attribute_changed)

# ABSTRACT FUNCTION
func _attribute_changed(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: NetworkPremise._attribute_changed()")

# ABSTRACT FUNCTION
func _add_instance(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: NetworkPremise._add_instance()")

# ABSTRACT FUNCTION
func _delete_instance(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: NetworkPremise._instance_deleted()")
