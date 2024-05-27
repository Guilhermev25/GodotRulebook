@tool
extends HBoxContainer

var monitorable_script: Script


func _ready():
	%OperatorOption.clear()
	for operator in RulePremise.OPERATOR_HINTS:
		%OperatorOption.add_item(operator)


func set_monitorable_hints(script: Script) -> void:
	monitorable_script = script
	
	%AttributeOption.clear()
	%AttributeField.get_node("AttributeOption").clear()
	if script:
		for attribute: String in get_attribute_hints():
			%AttributeOption.add_item(attribute)
			%AttributeField.get_node("AttributeOption").add_item(attribute)


func get_attribute_hints() -> Array[String]:
	var result: Array[String]
	for property: Dictionary in monitorable_script.get_script_property_list():
		if is_valid_attribute(property["name"]):
			result.append(property["name"])
	return result


func is_valid_attribute(attr: String) -> bool:
	var result: bool = (
		attr != "holder"
		and attr != "rulebook"
		and not attr.ends_with(".gd")
	)
	return result


func _on_delete_premise_pressed():
	queue_free()


func _on_constant_pressed():
	change_active_field("Constant")


func _on_attribute_pressed():
	change_active_field("Attribute")


func _on_variable_pressed():
	change_active_field("Variable")


func change_active_field(new_field: String):
	for field: Control in [%ConstantField, %AttributeField, %VariableField]:
		field.visible = false
	for check_box: CheckBox in %OperandTypeOptions.get_children():
		if check_box.name != new_field:
			check_box.button_pressed = false
	get_node("%" + new_field + "Field").visible = true
