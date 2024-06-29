class_name Filter


static func filter_properties(script: Script) -> Array[Dictionary]:
	var base_class := script.get_base_script()
	var base_properties := base_class.get_script_property_list()
	var properties := script.get_script_property_list()
	var result: Array[Dictionary] = []
	for property in properties:
		if property not in base_properties \
		and not property.name.ends_with(".gd"):
			result.append(property)
	return result
