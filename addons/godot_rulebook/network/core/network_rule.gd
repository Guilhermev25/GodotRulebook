class_name NetworkRule
extends Rule

signal satisfied(rule: NetworkRule)
signal unsatisfied(rule: NetworkRule)
var solutions: Array[Dictionary] = []


func _init() -> void:
	condition = NetworkCondition.new()
	condition.add_solution.connect(on_add_solution)
	condition.remove_solution.connect(on_remove_solution)


func on_add_solution(solution: Dictionary) -> void:
	if solutions.is_empty():
		satisfied.emit(self)
	solutions.append(solution)


func on_remove_solution(solution: Dictionary) -> void:
	solutions.erase(solution)
	if solutions.is_empty():
		unsatisfied.emit(self)


func resolve(rulebook: Rulebook) -> void:
	var resolution = load(resolution_path).new()
	for solution in solutions:
		resolution.rule_match = solution
		resolution.rulebook = rulebook
		await resolution._resolve()
	solutions.clear()
