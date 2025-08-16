extends Node
class_name EffectComponent

signal status_updated(effects: Array[Effect])

@export var health_component : HealthComponent

var effects : Array[Effect] = []
var process_effects : Array[ProcessEffect] = []


func sort_effects(a: Effect, b: Effect) -> bool:
	return a.visual.name < b.visual.name


func effect_count(effect: Effect) -> int:
	var v := 0
	for i in effects:
		if i.visual == effect.visual:
			v += 1
	return v


func set_status(effect: Effect):
	if health_component.can_take_damage:
		if effect is DurationEffect:
			if (not effect.infinite_stack_count 
					and effect_count(effect) >= effect.max_stack_count):
				var v = get_oldest_effect(effect)
				if v != null:
					remove_effect(v)
				else:
					return
		
		if effect is ProcessEffect:
			process_effects.append(effect)
			if not effect.is_connected("ended", remove_effect):
				effect.ended.connect(remove_effect)
		
		effects.append(effect)
		
		effects.sort_custom(sort_effects)
		status_updated.emit(effects)
		
		effect.effect_applied(self)


func _process(delta: float) -> void:
	for i in process_effects:
		i.effect_process(delta, self)


func get_oldest_effect(effect: Effect) -> Effect:
	for i in process_effects:
		if i.name == effect.name:
			return i
	return null


func remove_effect(effect: Effect):
	#print("Effect removed: ", effect.name)
	effects.erase(effect)
	
	if effect is ProcessEffect:
		process_effects.erase(effect)
	
	status_updated.emit(effects)
