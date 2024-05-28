class_name NetworkRule
extends Rule

signal rule_satisfied(rule: Rule)
signal rule_unsatisfied(rule: Rule)


func on_predicate_satisfied() -> void:
	rule_satisfied.emit(self)


func on_predicate_unsatisfied() -> void:
	rule_unsatisfied.emit(self)
