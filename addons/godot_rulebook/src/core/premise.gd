@tool
class_name Premise
extends Node

enum OperandType { CONSTANT, ATTRIBUTE, VARIABLE }
const OPERATOR_HINTS = ["==", "!=", ">", ">=", "<", "<="]
@export var monitorable_type: String
@export var attribute: String
@export var operator: String
@export var operand_type: OperandType
@export var operand: String
@export var expression_string: String = ""
var expression: Expression


func _ready() -> void:
	name = get_hash()


func parse_expression() -> void:
	expression = Expression.new()
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


func get_hash() -> String:
	if expression_string == "":
		parse_expression()
	return monitorable_type + " " + expression_string
