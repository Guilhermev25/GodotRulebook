class_name NetworkCondition
extends Condition

signal add_solution(solution: Dictionary)
signal remove_solution(solution: Dictionary)
var premises_variables: Dictionary
var variable_processing := VariableProcessing.new()


func _init():
	variable_processing.solution_found.connect(on_solution_found)
	variable_processing.invalidate_solution.connect(on_invalidate_solution)


func on_solution_found(solution: Dictionary) -> void:
	add_solution.emit(solution)


func on_invalidate_solution(solution: Dictionary) -> void:
	remove_solution.emit(solution)


func add_var_association(premise: NetworkPredicate, variable: String) -> void:
	premises_variables[premise] = variable


func get_premise_var(premise: NetworkPredicate) -> String:
	return premises_variables[premise]
