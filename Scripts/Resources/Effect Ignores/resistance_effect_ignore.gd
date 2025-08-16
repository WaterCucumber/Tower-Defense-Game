extends BaseEffectIgnore
class_name ResistanceEffectIgnore

@export var ignore_part := 0.0
@export var can_be_less_than_zero := false


func set_resistance(resistance_effect: ResistanceHealthEffect) -> ResistanceHealthEffect:
	var resistance : float = resistance_effect.resistance_pct * (1 - ignore_part)
	var result := resistance_effect.duplicate()
	result.resistance_pct = max(resistance, 0) if can_be_less_than_zero else resistance
	return result


func change_effect(effects: Array[BaseHealthEffect]) -> Array[BaseHealthEffect]:
	var new_effects : Array[BaseHealthEffect] = []
	for i in effects:
		var item := i
		if i is ResistanceHealthEffect:
			item = set_resistance(i)
		new_effects.append(item)
	return new_effects
