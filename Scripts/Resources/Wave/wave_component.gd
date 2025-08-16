@tool
extends JsonResource
class_name WaveComponent

@export var enemy : EnemySettings
@export var count := 1
@export_range(0.1, 10) var spawn_cooldown := 1.0
@export var await_time_after := 0.0


func load_from_dict(dict: Dictionary) -> void:
	enemy = Database.enemy_json_to_enemy(dict.get_or_add("enemy", "ghost"))
	count = dict.get_or_add("count", 1)
	spawn_cooldown = dict.get_or_add("spawn_cooldown", 1.0)
	await_time_after = dict.get_or_add("await_time_after", 0.0)


func export_value(value):
	if value is EnemySettings:
		return Database.enemy_dict.find_key(value)
	return super.export_value(value)
