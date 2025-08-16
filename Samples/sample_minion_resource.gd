extends JsonResource
class_name Minion

@export var name := ""
@export var damage := 5
@export var duration := 1.0
@export var comb : DataRes

func load_from_dict(dict: Dictionary) -> void:
	name = dict.get_or_add("name", "Empty")
	damage = dict.get_or_add("damage", 5)
	duration = dict.get_or_add("duration", 1.0)
	if dict.has("comb"):
		comb = DataRes.new()
		var comb_v = dict.get_or_add("comb", null)
		if comb_v:
			comb.load_from_dict(comb_v)
		else:
			comb = null
