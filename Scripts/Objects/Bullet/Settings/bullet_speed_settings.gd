extends Resource
class_name BulletSpeedSettings

@export var base_speed := 300.0

func get_speed(_life_time: float, _life_time_left: float) -> float:
	return base_speed


func get_averange_speed() -> float:
	return base_speed
