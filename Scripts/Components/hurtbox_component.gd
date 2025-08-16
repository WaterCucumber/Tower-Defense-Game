extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var effect_component: EffectComponent

##source - self take_damage caller (HitboxComponent, EffectComponent, self, etc.)
func take_damage(source: Object, damage):
	health_component.take_damage(source, damage)


func set_status(effect: Effect):
	if effect_component:
		effect_component.set_status(effect)
