@tool
class_name Predicate
extends Node

@export var monitorable_id: String
@export var monitorable_type: String
@export var premises: Array[Premise]


func _ready() -> void:
	name = monitorable_type + " " + monitorable_id
