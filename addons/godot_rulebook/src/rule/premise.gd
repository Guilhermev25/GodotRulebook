class_name RulePremise
extends Resource

enum OperandType { CONSTANT, ATTRIBUTE, VARIABLE }
const OPERATOR_HINTS = ["==", "!=", ">", ">=", "<", "<="]
var type: String
var attribute: String
var operator: String
var operand_type: OperandType
var operand: String
var expression_string: String
var expression = Expression.new()


func check_validity() -> bool:
	# TODO: Check whether the premise attributes are valid
	return true


func parse_expression() -> void:
	match operand_type:
		OperandType.CONSTANT:
			expression_string = "instance.%s %s %s" % [attribute, operator, operand]
			expression.parse(expression_string, ["instance"])
		OperandType.ATTRIBUTE:
			expression_string = "instance.%s %s instance.%s" % [attribute, operator, operand]
			expression.parse(expression_string, ["instance"])
		OperandType.VARIABLE:
			expression_string = "instance.%s %s var" % [attribute, operator]
			expression.parse(expression_string, ["instance", "var"])


func connect_instance(instance: Monitorable) -> void:
	instance.connect(attribute + "_changed", _property_changed)
	if operand_type == OperandType.ATTRIBUTE:
		instance.connect(operand + "_changed", _property_changed)
	_add_instance(instance)
	instance.connect("deleted", _instance_deleted)


func get_hash() -> void:
	var hash_string := "type: %s %s" % [type, expression_string]
	# NOTE: Remove hash() to avoid collisions?
	return hash_string.hash()


# ABSTRACT FUNCTION
func _property_changed(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._property_changed()")

# ABSTRACT FUNCTION
func _add_instance(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._add_instance()")

# ABSTRACT FUNCTION
func _instance_deleted(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._instance_deleted()")


