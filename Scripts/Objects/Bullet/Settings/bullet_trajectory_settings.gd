extends Resource
class_name BulletTrajectorySettings

enum OffsetType{
	X,
	Y,
	XY
}

@export var offset_type := OffsetType.Y

func get_offset(_life_time: float) -> Vector2:
	return Vector2.ZERO
