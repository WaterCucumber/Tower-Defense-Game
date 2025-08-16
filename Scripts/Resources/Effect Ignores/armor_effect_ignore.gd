extends BaseEffectIgnore
class_name ArmorEffectIgnore

@export var ignore_value := 0.0
@export var can_be_less_than_zero := false

func set_armor(armor_effect: ArmorHealthEffect) -> ArmorHealthEffect:
	var armor := armor_effect.armor - ignore_value
	var result := armor_effect.duplicate()
	result.armor = max(armor, 0) if can_be_less_than_zero else armor
	return result


func change_effect(effects: Array[BaseHealthEffect]) -> Array[BaseHealthEffect]:
	var new_effects : Array[BaseHealthEffect] = []
	for i in effects:
		var item := i
		if i is ArmorHealthEffect:
			item = set_armor(i)
		new_effects.append(item)
	return new_effects
