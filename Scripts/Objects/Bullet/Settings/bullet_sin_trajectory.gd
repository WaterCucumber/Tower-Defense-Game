extends BulletTrajectorySettings
class_name BulletSinTrajectory

@export_group("Sin")
@export var offset := 0.0
@export var amplitude := 1.0
@export var period_time := 1.0
@export var only_positive := false

var actual_period_time: float:
	get():
		return TAU / period_time


func get_value(x: float):
	var v := sin((x + offset) * actual_period_time) * amplitude
	if only_positive:
		return v / 2 + amplitude / 2
	return v


func get_offset(life_time: float) -> Vector2:
	match offset_type:
		OffsetType.X:
			return Vector2(get_value(life_time), 0)
		OffsetType.Y:
			return Vector2(0, get_value(life_time))
		OffsetType.XY:
			return Vector2(get_value(life_time), get_value(life_time))
	return Vector2(0, get_value(life_time))
