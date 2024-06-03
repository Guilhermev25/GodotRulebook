class_name NetworkBuilder


static func compile_rulebook(rulebook: Rulebook) -> CompiledRulebook:
	# TODO: Offer saveable version using Node tree and scenes
	var compiled_rulebook := build_compiled_rulebook(rulebook)
	connect_network(compiled_rulebook)
	return compiled_rulebook


static func build_compiled_rulebook(rulebook: Rulebook) -> CompiledRulebook:
	var compiled_rulebook := CompiledRulebook.new()
	var all_premises: Dictionary # String: NetworkPremise
	var context: Dictionary = { 
		"all_premises": all_premises,
		"compiled_rulebook": compiled_rulebook,
	}
	for rule: Rule in rulebook.rules:
		var network_rule := build_network_rule(rule, context)
		compiled_rulebook.add_rule(network_rule)
	return compiled_rulebook


static func build_network_rule(rule: Rule, context: Dictionary) -> NetworkRule:
	var network_rule := NetworkRule.new()
	network_rule.type = rule.type
	network_rule.resolution_path = rule.resolution_path
	var network_codition = NetworkCondition.new()
	network_rule.codition = network_codition
	for predicate: Predicate in rule.condition.predicates:
		context["network_codition"] = network_codition
		var network_predicate := build_network_predicate(predicate, context)
		network_rule.codition.add_predicate(network_predicate)
	return network_rule


static func build_network_predicate(predicate: Predicate, context: Dictionary) -> NetworkPredicate:
	var network_predicate := NetworkPredicate.new()
	network_predicate.monitorable_type = predicate.monitorable_type
	network_predicate.monitorable_id = predicate.monitorable_id
	for premise: Premise in predicate.premises:
		var network_premise := build_network_premise(premise, context)
		network_predicate.premises.append(network_premise)
	network_predicate.premises.append(create_id_premise(predicate))
	network_predicate.premises.sort_custom(sort_premises)
	return network_predicate


static func build_network_premise(premise: Premise, context: Dictionary) -> NetworkPremise:
	var is_variable: bool = premise.operand_type == Premise.OperandType.VARIABLE
	var network_premise := VariablePremise.new() if is_variable else SimplePremise.new()
	var variable: String = network_premise.operand
	premise_copy(premise, network_premise)
	network_premise.parse_expression()
	var all_premises: Dictionary = context["all_premises"]
	network_premise = all_premises.get_or_add(network_premise.get_hash(), network_premise)
	if is_variable:
		var network_codition: NetworkCondition = context["network_codition"]
		network_codition.add_var_association(network_premise, variable)
	var compiled_rulebook: CompiledRulebook = context["compiled_rulebook"]
	compiled_rulebook.add_premise(network_premise)
	return network_premise


static func create_id_premise(predicate: NetworkPredicate) -> NetworkPremise:
	var premise := NetworkPremise.new()
	premise.type = predicate.monitorable_type
	premise.attribute = "holder"
	premise.operator = "=="
	premise.operand_type = Premise.OperandType.VARIABLE
	premise.operand = predicate.monitorable_id
	return premise


static func premise_copy(origin: Premise, target: NetworkPremise) -> void:
	target.type = origin.type
	target.attribute = origin.attribute
	target.operator = origin.operator
	target.operand_type = origin.operand_type
	target.operand = origin.operand
	target.expression_string = origin.expression_string
	target.expression = origin.expression


static func sort_premises(a: NetworkPremise, b: NetworkPremise) -> bool:
	if a is SimplePremise and b is SimplePremise:
		return a.get_hash() < b.get_hash()
	elif a is SimplePremise and b is VariablePremise:
		return true
	else:
		return false


static func connect_network(rulebook: CompiledRulebook) -> void:
	var summed_conjunctions: Dictionary # String: Conjunction
	for rule: NetworkRule in rulebook.rules:
		for predicate: NetworkPredicate in rule.condition.predicates:
			var summed_hash := ""
			var previous_conjunction: Conjunction = null
			for premise: NetworkPremise in predicate.premises:
				if premise is SimplePremise:
					var conjunction := Conjunction.new()
					conjunction.premise = premise
					connect_conjunctons(previous_conjunction, conjunction)
					summed_hash += premise.get_hash()
					conjunction = summed_conjunctions.get_or_add(summed_hash, conjunction)
					connect_simple_premise(premise, conjunction)
					previous_conjunction = conjunction
				if premise is VariablePremise:
					# TODO: Implement VariablePremise connection
					pass


static func connect_simple_premise(premise: NetworkPremise, conjuntion: Conjunction) -> void:
	premise.add.connect(conjuntion.add_to_local_memory)
	premise.remove.connect(conjuntion.remove_from_local_memory)


static func connect_conjunctons(previous_conjunction: Conjunction, conjunction: Conjunction) -> void:
	if previous_conjunction == null or conjunction == null:
		return
	previous_conjunction.forward_add.connect(conjunction.add_to_local_memory)
	previous_conjunction.forward_remove.connect(conjunction.remove_from_local_memory)
