extends Area2D
class_name HitboxComponent

signal attacked(what: HurtboxComponent, damage)

@export var attack_component: AttackComponent
@export var effect_applier_component: EffectApplierComponent

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var damage : BaseDamage = attack_component.damage
		if effect_applier_component:
			effect_applier_component.set_status(area)
		area.take_damage(self, damage)
		attacked.emit(area, damage)
