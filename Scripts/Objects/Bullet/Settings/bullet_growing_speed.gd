extends BulletSpeedSettings
class_name BulletGrowingSpeed

@export var max_speed := 500.0

func get_speed(life_time: float, life_time_left: float) -> float:
	return lerp(base_speed, max_speed, 1 - life_time_left / life_time)


func get_averange_speed() -> float:
	return lerp(base_speed, max_speed, 0.5)
