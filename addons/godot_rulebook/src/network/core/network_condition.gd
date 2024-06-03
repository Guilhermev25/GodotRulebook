class_name NetworkCondition
extends Condition

signal condition_satisfied
signal condition_unsatisfied
var predicates_satisfied: int = 0
var premises_variables: Dictionary
var variable_processing := VariableProcessing.new()


func add_predicate(predicate: NetworkPredicate) -> void:
	predicate.predicate_satisfied.connect(on_predicate_satisfied)
	predicate.predicate_unsatisfied.connect(on_predicate_unsatisfied)


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


func add_var_association(premise: NetworkPredicate, variable: String) -> void:
	premises_variables[premise] = variable


func get_premise_var(premise: NetworkPredicate) -> String:
	return premises_variables[premise]
