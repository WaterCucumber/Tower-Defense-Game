extends Resource
class_name BaseHealth

@export var start_health : CountBase
@export var health_effects : Array[BaseHealthEffect]

var max_health := 10.0
var current_health := 10.0


var display_health :
	get():
		return max(Math.floor_d(current_health), 0)


var display_max_health :
	get():
		return max(Math.floor_d(max_health), 0)


var alive :
	get():
		return current_health > 0


func initialize():
	if start_health:
		current_health = start_health.get_count()
	else:
		push_error("No start health!")
		current_health = 0
	max_health = current_health


func take_damage(source: Object, damage) -> float:
	var is_base_damage := damage is BaseDamage
	var _damage : float = (
			0 if damage == null
			else float(damage) if damage is float or damage is int
			else damage.count.get_count() if is_base_damage
			else damage.get_count() if damage.has_method("get_count") 
			else 0)

	var result_damage := _damage
	var temp_health_effects : Array[BaseHealthEffect] = []
	if is_base_damage:
		temp_health_effects = damage.check_ignores(health_effects)
	else:
		temp_health_effects = health_effects
	
	for i in temp_health_effects:
		result_damage = i.get_damage(source, result_damage)
	current_health -= result_damage
	return result_damage
