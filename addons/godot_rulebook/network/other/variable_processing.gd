class_name VariableProcessing
extends Node

signal solution_found(solution: Dictionary)
signal invalidate_solution(solution: Dictionary)
var condition: NetworkCondition
var csp_nodes: Array[CSPNode]
var solutions: Array[Dictionary] = []
var partial_restrictions: Dictionary # String: Array[PartialRestriction]
var restrictions: Dictionary # int: Dictionary[ int: Array[Restriction] ]


func _init(_condition: NetworkCondition) -> void:
	condition = _condition


func create_node(premises: Array[VariablePremise], conjunction: Conjunction) -> void:
	var node := new_node()
	if conjunction != null:
		connect_conjunction(conjunction, node)
	else:
		connect_first_premise(premises[0], node)
	for premise: NetworkPremise in premises:
		connect_premise(premise, node)
		add_partial_restriction(premise, node)


func new_node() -> CSPNode:
	var node := CSPNode.new(csp_nodes.size())
	csp_nodes.append(node)
	node.added_to_domain.connect(on_domain_expansion)
	node.removed_from_domain.connect(on_domain_reduction)
	return node


func connect_conjunction(conjunction: Conjunction, node: CSPNode):
	conjunction.forward_add.connect(node.add_to_domain)
	conjunction.forward_remove.connect(node.remove_from_domain)


func connect_first_premise(premise: VariablePremise, node: CSPNode) -> void:
	premise.created.connect(node.add_to_domain)
	premise.deleted.connect(node.remove_from_domain)


func connect_premise(premise: VariablePremise, node: CSPNode) -> void:
	premise.update.connect(node.update_instance)


func add_partial_restriction(premise: VariablePremise, node: CSPNode) -> void:
	var variable: String = condition.get_premise_var(premise)
	var partial_restriction := PartialRestriction.new(premise.operator, node.id, premise.attribute)
	partial_restrictions[variable].append(partial_restriction)


func build_csp_graph() -> void:
	for key in partial_restrictions:
		var array: Array = partial_restrictions[key]
		for i in range(array.size()):
			for j in range(i + 1 , array.size()):
				var restriction := build_restriction(array[i], array[j])
				if restriction != null:
					add_restriction(restriction)
	partial_restrictions.clear()


func build_restriction(r: PartialRestriction, s: PartialRestriction) -> Restriction:
	if r.operator != "==" and s.operator != "==":
		return null
		
	var operator: String = r.operator if r.operator != "==" else s.operator
	# [NodeID].attr [operator] [NodeID].attr
	return Restriction.new(r.node, r.attribute, operator, s.node, s.attribute)


func add_restriction(restriction: Restriction) -> void:
	var left := restriction.left
	var right := restriction.right
	
	if restrictions.has(left):
		restrictions[left][right].append(restriction)
	else:
		var array := [restriction]
		restrictions[left] = { 
			right: array 
		}
		restrictions[right] = { 
			left: array 
		}


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


func find_solutions(source: CSPNode, instance: Monitorable) -> Array[Dictionary]:
	if empty_domains():
		return []
	return []


class PartialRestriction:
	var operator: String
	var node: int
	var attribute: String
	
	func _init(_operator: String, _node: int, _attribute: String) -> void:
		operator = _operator
		node = _node
		attribute = _attribute


class Restriction:
	var string: String
	var left: int
	var right: int
	var expression := Expression.new()
	
	func _init(l_node: int, l_attr: String, operator: String, r_node: int, r_attr: String) -> void:
		left = l_node
		right = r_node
		string = "%s.%s %s %s.%s" % [l_node, l_attr, operator, r_node, r_attr]
		expression.parse(string, [str(l_node), str(r_node)])
	
	func evaluate(instances: Dictionary) -> bool:
		var l_instance: Monitorable
		var r_instance: Monitorable
		
		for node in instances:
			if left == node:
				l_instance = instances[node]
			elif right == node:
				r_instance = instances[node]
		
		return expression.execute([l_instance, r_instance])
