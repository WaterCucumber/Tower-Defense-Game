@tool
extends EditorScript

func _run():
	var resource_path = "res://Resources/Settings/Levels/level_test.tres"
	save_all_resources([resource_path, "res://Resources/Settings/Levels/level_1.tres"])


func save_all_resources(resources_paths : Array[String]):
	print_rich("[b]---- SAVING DATA START ----[/b]")
	for resource_path in resources_paths:
		save_resource(resource_path)
	print_rich("[b]---- SAVING DATA END ----[/b]")


func save_resource(resource_path: String, dict := {}):
	var resource := load(resource_path) as JsonResource
	var folders := resource_path.trim_prefix("res://").trim_suffix(".tres").split("/")
	var resource_name := folders[-1]

	print_rich("[color=green]Starting: [/color][b]%s[/b]" % resource_name)

	folders.remove_at(folders.size()-1)
	# Папка для сохранения
	var folder_path = "user://" + "/".join(folders)
	var global_path := ProjectSettings.globalize_path(folder_path)
	
	# Создаем папку (если её нет)
	var dir := DirAccess.open("user://")
	if dir:
		print_rich("[color=orange]Creating directory: " + global_path + "[/color]")
		var creation_path := folder_path.trim_prefix("user://")
		if dir.dir_exists(creation_path):
			print("Directory already exists!")
		else:
			var err = dir.make_dir_recursive(creation_path)
			if err == OK:
				print("Directory created!")
			else:
				push_error("Failed to create directory! err = ", err)
		
		if dir.dir_exists(creation_path):
			print_rich("[color=cyan]Saving data:[/color]")
			if resource and resource is JsonResource:
				JsonParser.save_resource_to_json(resource.duplicate(true), folder_path + "/" + resource_name + ".json")
			else:
				JsonParser.save_to_json(dict, resource_path)
	else:
		push_error("Failed to open user:// directory")
	print_rich("[color=green]Ended: [/color][b]%s[/b]" % resource_name)
