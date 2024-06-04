class_name VariableProcessing
extends Node


func connect_to_predicate(predicate: NetworkPredicate, context: Dictionary) -> void:
	var assignment := Assignment.new()
	var eq_premises: Array[VariablePremise] = context["eq_premises"]
	for premise: VariablePremise in eq_premises:
		connect_assignment(premise, assignment)
	
	var last_conjunction: Conjunction = context["last_conjunction"]
	if last_conjunction:
		connect_conjunction(last_conjunction, assignment)
	else:
		connect_premise(eq_premises[0], assignment)
	
	var constraint := Constraint.new()
	var ineq_premises: Array[VariablePremise] = context["ineq_premises"]
	for premise: VariablePremise in ineq_premises:
		connect_constraint(premise, constraint)
		
	# TODO: Connect assignment to constraint


func connect_assignment(premise: VariablePremise, assignment: Assignment) -> void:
	premise.update.connect(assignment.update_instance)


func connect_conjunction(conjunction: Conjunction, assignment: Assignment):
	conjunction.forward_add.connect(assignment.add_to_local_memory)
	conjunction.forward_remove.connect(assignment.remove_from_local_memory)


func connect_premise(premise: VariablePremise, assignment: Assignment) -> void:
	premise.created.connect(assignment.add_to_local_memory)
	premise.deleted.connect(assignment.remove_from_local_memory)


func connect_constraint(premise: VariablePremise, constraint: Constraint) -> void:
	premise.update.connect(constraint.update_instance)

