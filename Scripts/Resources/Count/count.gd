extends CountBase
class_name Count

@export var count: float


func _init(new_count := 0.0) -> void:
	count = new_count


func get_count() -> float:
	return count


func get_averange_count() -> float:
	return count


func get_display_string() -> String:
	return str(Math.floor_d(count))


func increase(koef: float):
	count *= koef


func add(v: float):
	count += v
