class_name Resolution

var rulebook: Rulebook
# Set by Rulebook before calling this resolution
var rule_match: Dictionary

func _get(property: StringName) -> Variant:
	var result := rule_match.get(property, null)
	if result == null:
		push_error("Variable '%s' not found on rule match" % property)
	return result

# ABSTRACT FUNCTION
func _resolve():
	push_error("NOT IMPLEMENTED ERROR: Resolution._resolve()")
