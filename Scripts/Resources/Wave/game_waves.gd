@tool
extends JsonResource
class_name GameWaves

@export var start_money := 7.5
@export var start_health := 100.0
@export var waves: Array[Wave]


func load_from_dict(dict: Dictionary) -> void:
	start_money = dict.get_or_add("start_money", 7.5)
	start_health = dict.get_or_add("start_health", 100)
	
	var arr = dict.get_or_add("waves", [])
	waves.clear()
	for i in arr.size():
		waves.append(Wave.new())
		waves[i].load_from_dict(arr[i])
