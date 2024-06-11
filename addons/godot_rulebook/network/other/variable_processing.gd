class_name VariableProcessing
extends Node

signal solution_found(solution: Dictionary)
signal invalidate_solution(solution: Dictionary)
var csp_nodes: Array[CSPNode]
var solutions: Array[Dictionary] = []


func add_predicate(predicate: NetworkPredicate, premises: Array[VariablePremise], conjunction: Conjunction) -> void:
	var node := new_node(predicate.monitorable_id)
	for premise: NetworkPremise in premises:
		connect_premise(premise, node)
	if conjunction:
		connect_conjunction(conjunction, node)
	else:
		connect_first_premise(premises[0], node)


func new_node(variable: String) -> CSPNode:
	var node := CSPNode.new()
	csp_nodes.append(node)
	node.variable = variable
	node.added_to_domain.connect(on_domain_expansion)
	node.removed_from_domain.connect(on_domain_reduction)
	return node


func connect_premise(premise: VariablePremise, node: CSPNode) -> void:
	premise.update.connect(node.update_instance)


func connect_conjunction(conjunction: Conjunction, node: CSPNode):
	conjunction.forward_add.connect(node.add_to_domain)
	conjunction.forward_remove.connect(node.remove_from_domain)


func connect_first_premise(premise: VariablePremise, node: CSPNode) -> void:
	premise.created.connect(node.add_to_domain)
	premise.deleted.connect(node.remove_from_domain)


func build_csp_graph() -> void:
	pass


func on_domain_expansion(node: CSPNode, added_instance: Monitorable) -> void:
	var new_solutions := find_solutions(node, added_instance)
	for solution in new_solutions:
		solutions.append(solution)
		solution_found.emit(solution)


func on_domain_reduction(node: CSPNode, removed_instance: Monitorable) -> void:
	for i in range(solutions.size()):
		var solution: Dictionary = solutions[i]
		if solution[node.variable] == removed_instance:
			solutions.remove_at(i)
			invalidate_solution.emit(solution)


func empty_domains() -> bool:
	for node in csp_nodes:
		if node.domain.is_empty():
			return true
	return false


func find_solutions(node: CSPNode, instance: Monitorable) -> Array[Dictionary]:
	if empty_domains():
		return []
	return []

