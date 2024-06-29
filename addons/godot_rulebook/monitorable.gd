@tool
class_name Monitorable
extends Node

static var MONITORABLE_SCRIPT := load("res://addons/godot_rulebook/monitorable.gd")
const CHANGED_SUFFIX := "_changed"
signal deleted(emitter: Monitorable)
@export var holder: Node
@export var auto_monitoring: bool = true
@export var rulebook_name: String = ""
var rulebook: CompiledRulebook

# Overriding built-in virtual method
func _ready() -> void:
	if not Engine.is_editor_hint():
		rulebook = RulebooksManager.get_rulebook(rulebook_name)
		tree_exited.connect(func(): deleted.emit(self))
		if auto_monitoring:
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
func _validate_property(property: Dictionary):
	if property.name == "rulebook_name":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = RulebooksManager.get_rulebook_hints()

# Overriding built-in virtual method
func _set(property: StringName, value: Variant) -> bool:
	var signal_name := property + CHANGED_SUFFIX 
	if not Engine.is_editor_hint() and has_signal(signal_name):
		emit_signal(signal_name, self)
		return true
	else:
		return false

# Tells rulebook to monitor this object. 
# "attribute_changed" signals will be connected internally.
func start_monitoring(rulebook: CompiledRulebook) -> void:
	# Create signals for each monitorable property 
	# (used to monitor changes to attribute values).
	var properties: Array[Dictionary] = Filter.filter_properties(get_script()) 
	for property in properties:
		var signal_name: String = property.name + CHANGED_SUFFIX
		var args := [{ 
			"name": "source", 
			"type": TYPE_OBJECT 
			}]
		add_user_signal(signal_name, args)
	rulebook.add_monitorable_instance(self)
