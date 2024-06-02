class_name NetworkRule
extends Rule

signal rule_satisfied(rule: NetworkRule)
signal rule_unsatisfied(rule: NetworkRule)


func on_condition_satisfied() -> void:
	rule_satisfied.emit(self)


func on_condition_unsatisfied() -> void:
	rule_unsatisfied.emit(self)
