extends ProcessEffect
class_name DurationEffect

@export var max_stack_count := 5
@export var infinite_stack_count := false
@export var duration := 5.0
@export var is_infinite := false
var time_left := 5.0


func effect_applied(_target: EffectComponent):
	time_left = duration


func effect_process(delta: float, _target: EffectComponent):
	if is_infinite: return
	time_left -= delta
	if time_left <= 0:
		ended.emit(self)


func get_display_value() -> String:
	return str(time_left)
