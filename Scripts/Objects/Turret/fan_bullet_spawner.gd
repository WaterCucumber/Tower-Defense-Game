extends BulletCountSpawner
class_name FanBulletSpawner

@export_group("Fan Spawner")
@export var spread : CountBase


func spawn_bullet_pattern(spread_angle: float, target: Node2D):
	var bullet_count := int(get_bullet_count())

	if bullet_count == 1:
		var angle = global_rotation
		var dir := Vector2(cos(angle), sin(angle))
		spawn_bullet(center_pos, angle, dir, target)
	else:
		var start_angle = -spread_angle / 2 + global_rotation
		var angle_step = spread_angle / max(bullet_count - 1, 1)
		for i in bullet_count:
			var angle = start_angle + i * angle_step
			var dir := Vector2(cos(angle), sin(angle))
			spawn_bullet(center_pos, angle, dir, target)


func _spawn_bullet_process(target: Node2D) -> void:
	spawn_bullet_pattern(deg_to_rad(spread.get_count()), target)
