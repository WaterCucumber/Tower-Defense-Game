extends CountBase
class_name PercentCount

@export_custom(PROPERTY_HINT_RANGE, "0,1,or_greater,or_less") var percent := 1.0
@export var base_count : CountBase

func get_count() -> float:
	return base_count.get_count() * percent


func get_averange_count() -> float:
	return get_count()


func get_display_string() -> String:
	return str(Math.floor_d(get_count()))


func increase(koef: float):
	percent *= koef


func add(v: float):
	percent += v
