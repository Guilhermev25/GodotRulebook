class_name Rule
extends Node

enum RuleType { AMEND, RESOLVE, CHAIN }
@export var type: RuleType
@export var condition := Condition.new()
@export var resolution_path: String
