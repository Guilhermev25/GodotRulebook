@tool
extends PanelContainer

const MONITORABLE_PREMISES := preload("res://addons/godot_rulebook/editor/components/monitorable_premises.tscn")


func _on_fold_rule_button_toggled(toggled_on: bool):
	%ContentsMargin.visible = toggled_on


func _on_delete_rule_pressed():
	queue_free()


func _on_add_monitorable_pressed():
	var new_monitorable: Control = MONITORABLE_PREMISES.instantiate()
	%Monitorables.add_child(new_monitorable)
	%Monitorables.move_child(new_monitorable, %AddMonitorableSection.get_index())
