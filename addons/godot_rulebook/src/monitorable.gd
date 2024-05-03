@tool
class_name Monitorable
extends Node

signal deleted(emitter: Monitorable)

@export var holder: Node
@export var rulebook_name: String = ""


func _ready() -> void:
	if not Engine.is_editor_hint():
		# Create signals for each monitorable property (used to monitor changes to attribute values).
		var properties: Array[Dictionary] = get_property_list()
		for property in properties:
			add_user_signal(property.name + "_changed", [{ "name": "source", "type": TYPE_OBJECT }])
		
		# Tells a rulebook about this object creation. The signals will be connected internally.
		RulebooksManager.get_rulebook(rulebook_name).add_monitorable_instance(self)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not holder:
		warnings.append("Please set `Holder` to a non-empty value.")
		
	if rulebook_name == "":
		warnings.append("Please set `Rulebook Name` to a non-empty value.")
	
	return warnings


func _get_property_list() -> Array[Dictionary]:
	return [{
		name = "rulebook_name",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = get_rulebooks_hint()
	}]


func get_rulebooks_hint() -> String:
	var rulebooks: Array[Rulebook] = RulebooksManager.get_all_rulebooks()
	var hints := ""
	for rulebook in rulebooks:
		hints += rulebook.name + ","
	return hints


func _set(property: StringName, value: Variant) -> bool:
	property = value
	emit_signal(property, self)
	return true


func _exit_tree() -> void:
	deleted.emit(self)
