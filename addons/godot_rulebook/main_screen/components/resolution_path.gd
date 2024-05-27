@tool
extends LineEdit


func _on_file_dialog_file_selected(path: String):
	change_path(path)


func _on_text_submitted(path: String):
	if ResourceLoader.exists(path, "Script"):
		change_path(path)
	else:
		# TODO: Implement warning
		pass 


func change_path(path: String):
	text = path
