extends Node
class_name EffectApplierComponent

@export var effect : Effect


func set_status(hurtbox: HurtboxComponent):
	if effect:
		hurtbox.set_status(effect.duplicate())
