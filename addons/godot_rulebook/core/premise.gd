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
	var error
	
	expression_string = "%s %s %s" % [attribute, operator, operand]
	if operand_type == OperandType.VARIABLE:
		error = expression.parse(expression_string, [operand])
	else:
		error = expression.parse(expression_string)
	
	if error != OK:
		push_error(expression.get_error_text())


func get_hash() -> String:
	if expression_string == "":
		parse_expression()
	return monitorable_type + " " + expression_string
