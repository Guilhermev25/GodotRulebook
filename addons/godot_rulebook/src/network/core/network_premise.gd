class_name NetworkPremise
extends Premise


func connect_instance(instance: Monitorable) -> void:
	instance.connect(attribute + "_changed", _attribute_changed)
	if operand_type == OperandType.ATTRIBUTE:
		instance.connect(operand + "_changed", _attribute_changed)
	_add_instance(instance)
	instance.connect("deleted", _instance_deleted)

# ABSTRACT FUNCTION
func _attribute_changed(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._attribute_changed()")

# ABSTRACT FUNCTION
func _add_instance(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._add_instance()")

# ABSTRACT FUNCTION
func _instance_deleted(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._instance_deleted()")
