@tool
class_name EditorRule
extends PanelContainer


func _on_fold_rule_button_toggled(toggled_on: bool):
	%ContentsMargin.visible = toggled_on


func _on_add_monitorable_pressed():
	var new_monitorable: Control = RulebookEditorIO.EDITOR_MONITORABLE.instantiate()
	%Monitorables.add_child(new_monitorable)
	%Monitorables.move_child(new_monitorable, %AddMonitorableSection.get_index())


func _on_delete_rule_pressed():
	queue_free()
