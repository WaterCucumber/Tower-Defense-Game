extends TowerUpgradeStrategyBase
class_name CountUpgradeStrategy

@export var add_v := 1.0
@export var mult_v := 1.0

func changes_to_string() -> String:
	var result := ""
	var has_m := mult_v != 1
	var has_a := add_v != 0
	if has_m:
		result += "*" + str(mult_v) + (", " if has_a else "")
	if has_a:
		result += "+" + str(add_v)
	return result
