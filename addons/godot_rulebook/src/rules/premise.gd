class_name RulePremise
extends Resource

var monitored_instances: Dictionary
var expression = Expression.new()


func connect_instance(instance: Monitorable) -> void:
	pass


func _property_changed(instance: Monitorable) -> void:
	push_error("NOT IMPLEMENTED ERROR: Premise._property_changed()")
