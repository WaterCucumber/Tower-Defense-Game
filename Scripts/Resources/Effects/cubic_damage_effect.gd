extends DamageEffect
class_name CubicDamageEffect

@export var damage_period := 0.5
var damage_time := 0.0

func effect_applied(target: EffectComponent):
	super.effect_applied(target)
	damage_time = damage_period


func effect_process(delta: float, target: EffectComponent):
	super.effect_process(delta, target)
	damage_time -= delta
	
	if damage_time <= 0:
		target.health_component.take_damage(self, damage)
		damage_time = damage_period


func get_display_value() -> String:
	var damage_sign := "-" if damage.count.get_count() > 0 else "+" if damage.count.get_count() < 0 else ""
	return damage_sign + str(abs(damage.count.get_count())) + "/" + str(Math.floor_d(damage_period)) + "s"
