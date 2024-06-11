class_name CSPNode
extends Node

signal added_to_domain(source: CSPNode, instance: Monitorable)
signal removed_from_domain(source: CSPNode, instance: Monitorable)
var variable: String
var domain: Array[Monitorable]


func add_to_domain(instance: Monitorable) -> void:
	domain.append(instance)
	added_to_domain.emit(self, instance)


func remove_from_domain(instance: Monitorable) -> void:
	# NOTE: Maybe implement it using a Dictionary for faster erase?
	domain.erase(instance)
	removed_from_domain.emit(self, instance)


func update_instance(instance: Monitorable) -> void:
	remove_from_domain(instance)
	add_to_domain(instance)
