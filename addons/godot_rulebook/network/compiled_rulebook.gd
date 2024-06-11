class_name CompiledRulebook
extends Rulebook

var premises: Dictionary # String: Array[NetworkPremise]
var conflict_set: Dictionary # Rule.RuleType: Array[NetworkRule]
var effects_queue: Array[Effect]


func _init():
	for type in Rule.RuleType:
		conflict_set[type] = []
	print(conflict_set)


func add_monitorable_instance(instance: Monitorable) -> void:
	var instance_class: String = instance.get_script().get_global_name()
	var class_premises: Array[NetworkPremise] = premises[instance_class]
	for premise in class_premises:
		premise.connect_instance(instance)


func add_premise(premise: NetworkPremise) -> void:
	var class_premises: Array[NetworkPremise] = premises[premise.monitorable_type]
	class_premises.append(premise)


func add_rule(rule: NetworkRule) -> void:
	rules.append(rule)
	rule.satisfied.connect(on_rule_satisfied)
	rule.unsatisfied.connect(on_rule_unsatisfied)


func on_rule_satisfied(rule: NetworkRule) -> void:
	var rules: Array[NetworkRule] = conflict_set[rule.type]
	rules.erase(rule)
	rules.append(rule)


func on_rule_unsatisfied(rule: NetworkRule) -> void:
	conflict_set[rule.type].erase(rule) 


func enqueue_effect(effect: Effect):
	effects_queue.push_back(effect)


func dequeue_effect(effect: Effect):
	effects_queue.erase(effect)


func execute():
	var effect: Effect = effects_queue.pop_front()
	effect.start_monitoring(self)
	for type in conflict_set:
		for rule in conflict_set[type]:
			rule.resolve()
	effect.queue_free()
