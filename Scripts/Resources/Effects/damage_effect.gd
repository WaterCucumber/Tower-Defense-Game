extends DurationEffect
class_name DamageEffect

@export var damage : BaseDamage

func effect_applied(target: EffectComponent):
	super.effect_applied(target)
	target.health_component.take_damage(self, damage)


func get_display_value() -> String:
	return str(damage)
