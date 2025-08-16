@tool
extends JsonResource
class_name Wave

@export var components : Array[WaveComponent]


func load_from_dict(dict: Dictionary) -> void:
	var arr = dict.get_or_add("components", [])
	components.clear()
	for i in arr.size():
		components.append(WaveComponent.new())
		components[i].load_from_dict(arr[i])
