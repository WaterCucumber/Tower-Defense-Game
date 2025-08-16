extends ProcessEffect
class_name DelayedEffect

@export var main_effect : Effect
@export var delay := 1.0
@export var loop := false
@export var apply_on_start := false
var time := 0.0
var applied := false


func effect_applied(target: EffectComponent):
	if apply_on_start:
		target.set_status(main_effect)


func effect_process(delta: float, target: EffectComponent):
	if applied: return

	if time >= delay:
		if loop: time = 0
		else: 
			applied = true 
			ended.emit(self)
		target.set_status(main_effect)
	else:
		time += delta
