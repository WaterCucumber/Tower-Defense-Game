extends Resource
class_name Effect

@warning_ignore("unused_signal")
signal ended(effect: Effect)

@export var visual : EffectVisualisation


func get_display_value() -> String:
	return visual.name
