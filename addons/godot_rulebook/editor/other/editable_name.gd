@tool
extends Control

signal name_changed(new_name: String)
@export var placeholder_name: String:
	set(value):
		placeholder_name = value
		$Label.text = placeholder_name
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

func rename(new_text: String) -> void:
	$Label.text = new_text
	name_changed.emit(new_text)

func close_popup() -> void:
	$Label.visible = true
	$LineEdit.visible = false
