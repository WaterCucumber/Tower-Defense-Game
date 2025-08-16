extends CountBase
class_name RandomCount

@export var min_count_koef := 1.0
@export var min_count : CountBase

@export var max_count_koef := 1.0
@export var max_count : CountBase


func get_count() -> float:
	return randf_range(min_count.get_count(), max_count.get_count())


func get_averange_count() -> float:
	return lerp(min_count.get_averange_count(), max_count.get_averange_count(), 0.5)


func get_display_string() -> String:
	return "[" + str(Math.floor_d(min_count.get_count())) + "; " + str(Math.floor_d(max_count.get_count())) + "]"


func increase(koef: float):
	min_count.increase(koef * min_count_koef)
	max_count.increase(koef * max_count_koef)


func add(v: float):
	min_count.add(v * min_count_koef)
	max_count.add(v * max_count_koef)
