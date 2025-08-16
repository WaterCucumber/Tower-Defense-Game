class_name JsonParser

static func save_resource_to_json(json_resource: JsonResource, json_save_path: String) -> void:
	save_to_json(json_resource.export_to_dict(), json_save_path)

static func load_resource_from_json(json_resource: JsonResource, path_to_json: String) -> void:
	json_resource.load_from_dict(load_from_json(path_to_json))


static func save_to_json(export_dict : Dictionary, json_save_path: String) -> void:
	var json_string = JSON.stringify(export_dict, "\t")
	var file = FileAccess.open(json_save_path, FileAccess.WRITE)
	var absolute_path := ProjectSettings.globalize_path(json_save_path)
	
	if file.get_error() == OK:
		file.store_string(json_string)
		file.close()
		print("JSON file saved at ", absolute_path)
	else:
		push_error("There was an error while openinig file: " + absolute_path)


static func load_from_json(path_to_json: String) -> Dictionary:
	var file = FileAccess.open(path_to_json, FileAccess.READ)
	if file and file.get_error() == OK:
		var parse_result = JSON.parse_string(file.get_as_text())
		if parse_result is not Dictionary:
			print("There was an error while parsing JSON: parsed JSON is not Dictionary!")
			return {}
		file.close()
		print("File loaded from ", ProjectSettings.globalize_path(path_to_json))
		return parse_result
	else:
		printerr("Can't find file or there was an error!")
	return {}
