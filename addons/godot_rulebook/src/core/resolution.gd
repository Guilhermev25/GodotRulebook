class_name Resolution
extends Script

# Set by Rulebook before calling this resolution
var match_result: Dictionary


func _get(key: StringName):
  return match_result.get(key)

# ABSTRACT FUNCTION
func _resolve():
  push_error("NOT IMPLEMENTED ERROR: RuleResolution._resolve()")
