@tool
extends Resource
class_name JsonResource

# Список свойств, которые нужно экспортировать
@export var add_to_export : Array[String] = []
# Список свойств, которые нужно игнорировать
@export var not_allowed_to_export : Array[String] = ["add_to_export", "not_allowed_to_export", "choosen_properties", "metadata/_custom_type_script", "resource_local_to_scene", "resource_name", "resource_path", "script"]

func export_value(value):
	if value is JsonResource:
		return value.export_to_dict()
	elif value is Array:
		var arr = []
		for elem in value:
			arr.append(export_value(elem))
		return arr
	elif value is Dictionary:
		var dict = {}
		for k in value.keys():
			dict[k] = export_value(value[k])
		return dict
	else:
		return value


func export_to_dict() -> Dictionary:
	var export_dict = {}
	var props = get_property_list()
	for prop in props:
		if (add_to_export.has(prop.name) 
			or (prop.usage & PROPERTY_USAGE_EDITOR != 0
			and not not_allowed_to_export.has(prop.name))):
			var val = get(prop.name)
			export_dict[prop.name] = export_value(val)
	return export_dict

## You must override this!
func load_from_dict(_dict: Dictionary) -> void:
	pass
