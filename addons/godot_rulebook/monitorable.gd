@tool
class_name Monitorable
extends Node

signal deleted(emitter: Monitorable)
@export var holder: Node
@export var auto_monitoring: bool = true
var rulebook_name: String = ""
@onready var rulebook: CompiledRulebook = RulebooksManager.get_rulebook(rulebook_name)

# Overriding built-in virtual method
func _ready() -> void:
	if not Engine.is_editor_hint() and auto_monitoring:
		start_monitoring(rulebook)

# Overriding built-in virtual method
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not holder:
		warnings.append("Please set `Holder` to a non-empty value.")
		
	if rulebook_name == "":
		warnings.append("Please set `Rulebook Name` to a non-empty value.")
	
	return warnings

# Overriding built-in virtual method
func _get_property_list() -> Array[Dictionary]:
	return [{
		name = "rulebook_name",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = RulebooksManager.get_rulebook_hints()
	}]

# Overriding built-in virtual method
func _set(property: StringName, value: Variant) -> bool:
	property = value
	emit_signal(property, self)
	return true

# Overriding built-in virtual method
func _exit_tree() -> void:
	deleted.emit(self)

# Tells rulebook to monitor this object. 
# "attribute_changed" signals will be connected internally.
func start_monitoring(rulebook: CompiledRulebook) -> void:
	# Create signals for each monitorable property 
	# (used to monitor changes to attribute values).
	var properties: Array[Dictionary] = get_property_list()
	for property in properties:
		add_user_signal(
			property.name + "_changed", 
			[{ "name": "source", "type": TYPE_OBJECT }]
		)
	
	rulebook.add_monitorable_instance(self)
