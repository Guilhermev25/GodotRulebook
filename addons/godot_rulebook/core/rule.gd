class_name Rule
extends Node

enum RuleType { AMEND, RESOLVE, CHAIN }
@export var type: RuleType
@export var condition := Condition.new()
@export var resolution_path: String


static func greater(a: Rule, b: Rule) -> bool:
	return a.type > b.type
