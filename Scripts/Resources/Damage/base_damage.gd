extends Resource
class_name BaseDamage

@export var count : CountBase
@export var ignores : Array[BaseEffectIgnore]

func check_ignores(effects : Array[BaseHealthEffect]) -> Array[BaseHealthEffect]:
	var result := effects.duplicate()
	for i in ignores:
		result = i.change_effect(result)
	return result
