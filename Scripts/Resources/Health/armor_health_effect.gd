extends BaseHealthEffect
class_name ArmorHealthEffect

@export var armor := 1.0
@export var can_be_less_than_zero := false

func get_damage(_source: Object, damage: float) -> float:
	if damage < 0: return damage
	var v := damage - armor
	return v if can_be_less_than_zero else max(v, 0)


func get_display_value() -> String:
	return str(armor)
