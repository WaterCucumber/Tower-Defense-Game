extends DamageEffect
class_name DamageOverTimeEffect

func effect_applied(_target: EffectComponent):
	time_left = duration


func effect_process(delta: float, target: EffectComponent):
	super.effect_process(delta, target)
	var temp_damage := damage.duplicate(true)
	temp_damage.count.increase(delta)
	target.health_component.take_damage(self, temp_damage)


func get_display_value() -> String:
	var damage_sign := "-" if damage.count.get_count() > 0 else "+" if damage.count.get_count() < 0 else ""
	return damage_sign + str(abs(damage.count.get_count())) + "/s"
