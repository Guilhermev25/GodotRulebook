class_name Premise
extends Node

enum OperandType { CONSTANT, ATTRIBUTE, VARIABLE }
const OPERATOR_HINTS = ["==", "!=", ">", ">=", "<", "<="]
var type: String
var attribute: String
var operator: String
var operand_type: OperandType
var operand: String
var expression_string: String
var expression = Expression.new()


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


func get_hash() -> void:
	var hash_string := "type: %s %s" % [type, expression_string]
	# NOTE: Remove hash() to avoid collisions?
	return hash_string.hash()
