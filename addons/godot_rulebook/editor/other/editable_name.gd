@tool
extends Control

signal name_changed(new_name: String)
@export var editable_name: String:
	set(value):
		editable_name = value
		$Label.text = editable_name
@export var label_settings: LabelSettings:
	set(value):
		label_settings = value
		$Label.label_settings = value
		$LineEdit["theme_override_font_sizes/font_size"] = label_settings.font_size


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.double_click:
		edit_name_popup()


func edit_name_popup() -> void:
	$LineEdit.text = $Label.text
	$Label.visible = false
	$LineEdit.visible = true


func rename(new_name: String) -> void:
	$Label.text = new_name
	name_changed.emit(new_name)
	editable_name = new_name


func close_popup() -> void:
	$Label.visible = true
	$LineEdit.visible = false
