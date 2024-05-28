class_name NetworkBuilder
extends Node


func compile_rulebook(rulebook: Rulebook) -> CompiledRulebook:
	var compiled_rulebook := CompiledRulebook.new()
	for rule: Rule in rulebook.rules:
		var network_rule: NetworkRule = build_network_rule(rule)
		compiled_rulebook.add_rule(network_rule)
	# TODO: Build the network
	# TODO: Offer saveable version using Node tree and scenes
	return compiled_rulebook


func build_network_rule(rule: Rule) -> NetworkRule:
	var network_rule := NetworkRule.new()
	network_rule.resolution = rule.resolution
	network_rule.predicate = build_network_predicate(rule.predicate)
	return network_rule


func build_network_predicate(predicate: Predicate) -> NetworkPredicate:
	var network_predicate := NetworkPredicate.new()
	for key in predicate.monitorables_premisses:
		var premises: Array[Premise] = predicate.monitorables_premisses[key]
		var network_premises: Array[NetworkPremise]
		for premise in premises:
			network_premises.append(build_network_premise(premise))
		network_predicate.monitorables_premisses[key] = network_premises
	return network_predicate


func build_network_premise(premise: Premise) -> NetworkPremise:
	var result: NetworkPremise
	if premise.operand_type == Premise.OperandType.VARIABLE:
		result = VariablePremise.new()
	else:
		result = SimplePremise.new()
	premise_copy(premise, result)
	result.parse_expression()
	return result


func premise_copy(origin: Premise, target: NetworkPremise) -> void:
	target.type = origin.type
	target.attribute = origin.attribute
	target.operator = origin.operator
	target.operand_type = origin.operand_type
	target.operand = origin.operand
	target.expression_string = origin.expression_string
	target.expression = origin.expression
