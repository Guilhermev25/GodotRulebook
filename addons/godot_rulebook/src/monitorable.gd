@tool
class_name Monitorable
extends Node

signal deleted(emitter: Monitorable)

@export var holder: Node
var rulebook_name: String = ""


func _ready() -> void:
	if not Engine.is_editor_hint():
		# Create signals for each monitorable property (used to monitor changes to attribute values).
		var properties: Array[Dictionary] = get_property_list()
		for property in properties:
			add_user_signal(property.name + "_signal", [{ "name": "source", "type": TYPE_OBJECT }])
		
		# Tells Rulebook about this object creation. The signals will be connected internally.
		var rulebook = RulebooksManager.get_rulebook(rulebook_name)
		rulebook.add_monitorable_instance(self)


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
		usage = PROPERTY_USAGE_DEFAULT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = get_rulebooks_hint()
	}]


func get_rulebooks_hint() -> String:
	var rulebooks: Array[Rulebook] = RulebooksManager.get_rulebooks()
	var hints := ""
	for rulebook in rulebooks:
		hints += rulebook.rulebook_name + ","
	return hints


func _set(property: StringName, value: Variant) -> bool:
	property = value
	emit_signal(property, self)
	return true


func _exit_tree() -> void:
	deleted.emit(self)
