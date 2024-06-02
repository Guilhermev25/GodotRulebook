class_name NetworkCondition
extends Condition

signal condition_satisfied
signal condition_unsatisfied
var predicates_satisfied: int = 0


func on_predicate_satisfied() -> void:
	predicates_satisfied += 1
	if all_satisfied():
		condition_satisfied.emit(self)


func on_predicate_unsatisfied() -> void:
	if all_satisfied():
		condition_unsatisfied.emit(self)
	predicates_satisfied -= 1


func all_satisfied() -> bool:
	return predicates_satisfied == predicates.size()
