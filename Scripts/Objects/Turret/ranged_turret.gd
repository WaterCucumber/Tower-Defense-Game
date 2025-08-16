@icon("res://Assets/Node Icons/RangeTurret.png")
extends Tower
class_name RangedTower


@onready var fan_bullet_spawner: FanBulletSpawner = $FanBulletSpawner

var is_attacking := false
var need_play_animation := true

func _process(delta: float) -> void:
	super._process(delta)

	if animated_sprite.animation == "attack":
		var attack_frames_count := animated_sprite.sprite_frames.get_frame_count("attack")
		if animated_sprite.is_playing():
			if not _target and animated_sprite.frame == attack_frames_count - 1:
				animated_sprite.pause()
		else:
			animated_sprite.play("attack")


func initialize(start_tower_settings : TowerSettings):
	if start_tower_settings is not RangedTowerSettings:
		printerr("Initialized ranged turret with not RangedTowerSettings; tower_settings=", start_tower_settings)
		return
	
	super.initialize(start_tower_settings)

	fan_bullet_spawner.spawn_interval = tower_settings.cooldown
	fan_bullet_spawner.bullet_settings = tower_settings.bullet_settings

	fan_bullet_spawner.count = tower_settings.bullet_count
	fan_bullet_spawner.spread = tower_settings.spread
	turret_animation.attack_animation_finished.connect(func(): need_play_animation = false)


# ---------------Attack functions------------------
func _attack(target: Enemy):
	super._attack(target)
	if is_attacking: return
	is_attacking = true

	if need_play_animation:
		animated_sprite.play("attack")
		await turret_animation.attack_animation_finished

	if not is_instance_valid(target): 
		is_attacking = false
		return

	match tower_settings.offset_type:
		OffsetType.NONE:
			_set_attack_position(target.global_position)
		OffsetType.CONST:
			_set_attack_position(target.global_position 
					+ target.enemy_movement.delta_move 
					* (target.enemy_movement.speed / 5))
		OffsetType.BETTER:
			_set_attack_position(target.enemy_movement.get_next_position(0.75))
		OffsetType.BEST:
			var bullet_speed := fan_bullet_spawner.bullet_settings.bullet_speed.get_averange_speed()
			var distance := global_position.distance_to(target.global_position)
			var bullet_move_time := distance / bullet_speed
			_set_attack_position(target.enemy_movement.get_next_position(bullet_move_time))

	fan_bullet_spawner.look_at(_attack_pos)
	fan_bullet_spawner._spawn_bullet_process(target)
	queue_redraw()
	animated_sprite.play("post_attack")
	is_attacking = false
	need_play_animation = true


#region Signals
func _on_fov_area_area_entered(area: Area2D) -> void:
	if area.owner is not Enemy: return
	super._on_fov_area_area_entered(area)

	if _target and tower_settings and tower_settings.debug_target_pos: _target.modulate = Color.WHITE

	if _enemies_in_range.size() == 1:
		_target = area.owner
	else:
		_target = _get_first_target(_enemies_in_range)


func _on_fov_area_area_exited(area: Area2D) -> void:
	if area.owner is not Enemy: return
	super._on_fov_area_area_exited(area)

	if _target: _target.modulate = Color.WHITE

	if _enemies_in_range.size() == 0:
		_target = null
	else:
		_target = _get_first_target(_enemies_in_range)
#endregion
