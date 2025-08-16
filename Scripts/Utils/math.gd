class_name Math

static func floor_d(value: float, digit_to_floor := 1) -> float:
	var mult := 10 ** digit_to_floor
	return floor(value * mult) / mult
