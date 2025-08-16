extends BulletSpawner
class_name BulletCountSpawner

@export_group("Bullet Count")
@export var count: CountBase

func get_bullet_count() -> float :
	return count.get_count()
