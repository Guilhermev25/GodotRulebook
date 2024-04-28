class_name RuleResolution
extends Resource

# Set by Rulebook before calling this resolution
var match: Dictionary


func _get(key: StringName):
  return match.get(key)


func _resolve():
  pass
