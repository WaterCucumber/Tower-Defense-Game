@icon("res://Assets/Node Icons/MeleeTurret.png")
extends Tower
class_name MeleeTower

@export var collision_shape_2d: CollisionShape2D

@onready var weapon_rotationg_pos: Node2D = $WeaponRotationgPos
@onready var sword: Sprite2D = $WeaponRotationgPos/Attack/Sword
@onready var attack_component: AttackComponent = $AttackComponent

var is_attacking := false
var is_on_cooldown := false
var attack_time := 0.0
var cooldown_time := 0.0
var rotation_offset := 0.0

func initialize(start_tower_settings : TowerSettings):
	if start_tower_settings is not MeleeTowerSettings:
		printerr("Initialized melee turret with not MeleeTowerSettings; tower_settings=", tower_settings)
		return
	tower_settings = start_tower_settings
	sword.texture = tower_settings.weapon_texture
	attack_component.damage = tower_settings.damage
	super.initialize(tower_settings)


func _attack(target: Enemy):
	super._attack(target)
	if is_on_cooldown or is_attacking: return
	animated_sprite.play("attack")
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
			_set_attack_position(target.enemy_movement.get_next_position(0.1))

	_attack_animation()
	queue_redraw()


func _attack_animation():
	weapon_rotationg_pos.modulate *= 2
	collision_shape_2d.disabled = false
	rotation_offset = rad_to_deg(position.angle_to_point(_attack_pos))
	is_attacking = true


func _process(delta: float) -> void:
	super._process(delta)
	if is_attacking:
		attack_time += delta
		var swing_time : float = tower_settings.swing_time
		var rotating : Vector2 = tower_settings.swing_rotating
		if attack_time >= swing_time:
			attack_time = 0
			is_attacking = false
			is_on_cooldown = true
			collision_shape_2d.disabled = true
			weapon_rotationg_pos.rotation_degrees = rotating.x / 2 + rotation_offset
			weapon_rotationg_pos.modulate *= 0.5
		else:
			weapon_rotationg_pos.rotation_degrees = rotation_offset + lerpf(rotating.x, rotating.y, attack_time / swing_time)
	elif is_on_cooldown:
		cooldown_time += delta
		if cooldown_time >= tower_settings.cooldown.get_count():
			is_on_cooldown = false
			cooldown_time = 0
