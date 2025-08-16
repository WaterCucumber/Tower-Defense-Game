extends BaseHealthEffect
class_name ResistanceHealthEffect

@export var resistance_pct := 0.2
@export var can_be_less_than_zero := false

func get_damage(_source: Object, damage: float) -> float:
	if damage < 0: return damage
	var actual_damage := damage * (1 - resistance_pct)
	return actual_damage if can_be_less_than_zero else maxf(actual_damage, 0.0)


func get_display_value() -> String:
	return str(Math.floor_d(resistance_pct * 100))
