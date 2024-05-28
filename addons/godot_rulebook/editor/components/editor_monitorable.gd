@tool
class_name EditorMonitorable
extends VBoxContainer

var monitorable_type: String
var monitorable_script: Script


func _ready():
	set_monitorable_options()


func set_monitorable_options():
	%MonitorableType.clear()
	for class_dict: Dictionary in ProjectSettings.get_global_class_list():
		if class_dict["base"] == "Monitorable":
			var option: String = class_dict["class"].trim_prefix("Monitorable")
			%MonitorableType.add_item(option)


func _on_add_premise_pressed():
	var new_premise: Control = RulebookEditorIO.EDITOR_PREMISE.instantiate()
	%Premises.add_child(new_premise)
	new_premise.set_monitorable_hints(monitorable_script)
	%Premises.move_child(new_premise, %AddPremise.get_index())


func _on_monitorable_type_item_selected(index: int):
	monitorable_type = "Monitorable" + %MonitorableType.get_item_text(index)
	
	for class_dict: Dictionary in ProjectSettings.get_global_class_list():
		if class_dict["class"] == monitorable_type:
			monitorable_script = load(class_dict["path"])
	
	for premise: Control in %Premises.get_children():
		if premise != %AddPremise:
			premise.set_monitorable_hints(monitorable_script)


func _on_delete_monitorable_pressed():
	queue_free()
