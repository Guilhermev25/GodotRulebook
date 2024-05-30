class_name Rule
extends Node

enum RuleType { AMEND, RESOLVE, CHAIN }
var type: RuleType
var rule_name: String
var predicate: Predicate
var resolution: Resolution
