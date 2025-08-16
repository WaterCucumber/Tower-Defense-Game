@icon("res://Assets/Node Icons/Turret.png")
extends Node2D
class_name Tower

const RADIUS_TILE_EFFECT := 1.2 # +20%
const DAMAGE_TILE_EFFECT := 1.3 # +30%
const FIRE_RATE_TILE_EFFECT := 1.2 # -20%
const DISCOUNT_TILE_EFFECT := 0.5 # -50%

const BLIND_TILE_EFFECT := 1.2
const WEAKNESS_TILE_EFFECT := 1.3
const SLOWNESS_TILE_EFFECT := 1.2
const OVERPRICED_TILE_EFFECT := 1.5

enum OffsetType {NONE, CONST, BETTER, BEST}

@onready var fov_collision: CollisionShape2D = $"FOV Area/CollisionShape2D"
@onready var fov_area_visualize: CircleVisualizer = $"FOV Area Visualize"
@onready var turret_animation: Node = $TurretAnimation
@onready var animated_sprite: AnimatedSprite2D = $Animation/AnimatedSprite2D
@onready var animation: Node2D = $Animation

#var buffs :

var active := false

var tower_settings : TowerSettings
var shop_tower_settings : ShopTowerSettings
var towers_in_range := 0
var can_place : bool :
	get():
		return towers_in_range == 0

var _target : Enemy
var _attack_pos : Vector2
var _enemies_in_range : Array[Enemy]
var _is_mouse_on := false

func activate(new_shop_tower_settings : ShopTowerSettings, effect : BuildManager.TileEffectType):
	active = true
	shop_tower_settings = new_shop_tower_settings.duplicate(true)

	if not tower_settings:
		initialize(tower_settings)

	match effect:
		BuildManager.TileEffectType.NONE:
			pass
		BuildManager.TileEffectType.RADIUS:
			tower_settings.radius.increase(RADIUS_TILE_EFFECT)
		BuildManager.TileEffectType.FIRE_RATE:
			tower_settings.cooldown.increase(1 / FIRE_RATE_TILE_EFFECT)
		BuildManager.TileEffectType.DISCOUNTED:
			PlayerStats.instance.remove_money(-shop_tower_settings.tower_cost * DISCOUNT_TILE_EFFECT)
		BuildManager.TileEffectType.DAMAGE:
			tower_settings.get_damage().count.increase(DAMAGE_TILE_EFFECT)

		BuildManager.TileEffectType.BLIND:
			tower_settings.radius.increase(1 / BLIND_TILE_EFFECT)
		BuildManager.TileEffectType.SLOWNESS:
			tower_settings.cooldown.increase(SLOWNESS_TILE_EFFECT)
		BuildManager.TileEffectType.OVERPRICED:
			PlayerStats.instance.remove_money(shop_tower_settings.tower_cost * OVERPRICED_TILE_EFFECT)
		BuildManager.TileEffectType.WEAKNESS:
			tower_settings.get_damage().count.increase(1 / WEAKNESS_TILE_EFFECT)


func initialize(start_tower_settings : TowerSettings):
	tower_settings = start_tower_settings.duplicate(true)

	fov_collision.shape = CircleShape2D.new()
	fov_collision.shape.radius = tower_settings.actual_radius
	fov_area_visualize.create_new_circle()

	_initialize_animation(tower_settings)


func show_area():
	fov_area_visualize.show()


func hide_area():
	fov_area_visualize.hide()


func _initialize_animation(current_tower_settings: TowerSettings):
	var already_initialized : bool = (
			turret_animation.attack_anim == current_tower_settings.attack_anim)
	if already_initialized: return

	animated_sprite.scale = current_tower_settings.weapon_size
	turret_animation.attack_anim = current_tower_settings.attack_anim
	turret_animation.initialize((current_tower_settings.attack_anim.textures.size()-1) 
			/ current_tower_settings.cooldown.get_averange_count())


# ---------------Attack functions------------------
func _attack(target: Enemy):
	if tower_settings and tower_settings.debug_target_pos:
		target.modulate = Color.RED
	animation.look_at(target.global_position)


func _get_first_target(enemies: Array[Enemy]):
	var highest_ratio := -1.0
	var result : Enemy

	for i in enemies:
		if is_instance_valid(i):
			if i.progress_ratio > highest_ratio:
				highest_ratio = i.progress_ratio
				result = i

	return result


func _set_attack_position(new_pos: Vector2):
	_attack_pos = new_pos


func _process(_delta: float) -> void:
	if not active: return

	if _target:
		if _target.health_component.already_died:
			_enemies_in_range.erase(_target)
			_target = null
			return
		_target.modulate = Color.WHITE
		_attack(_target)
	elif _enemies_in_range.size() > 0:
		_target = _get_first_target(_enemies_in_range)


func _draw() -> void:
	if not active: return

	if tower_settings and tower_settings.debug_target_pos and _target:
		var local_attack_pos = to_local(_attack_pos)
		draw_circle(local_attack_pos, 5, Color.BROWN)
		draw_circle(Vector2.ZERO, 3, Color.GREEN, false, 2)
		draw_line(Vector2.ZERO, local_attack_pos, Color.BROWN, 2)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if _is_mouse_on and active:
			if event.button_index == MOUSE_BUTTON_LEFT:
				TowerUI.instance.set_target(self)


#region Signals
func _on_fov_area_area_entered(area: Area2D) -> void:
	# We don't use "active" because we need to get current _enemies_in_range
	if area.owner is not Enemy: return
	_enemies_in_range.append(area.owner)

	if _target and tower_settings and tower_settings.debug_target_pos: _target.modulate = Color.WHITE

	if _enemies_in_range.size() == 1:
		_target = area.owner
	else:
		_target = _get_first_target(_enemies_in_range)


func _on_fov_area_area_exited(area: Area2D) -> void:
	# We don't use "active" because we need to get current _enemies_in_range
	if area.owner is not Enemy: return
	_enemies_in_range.erase(area.owner)

	if _target: _target.modulate = Color.WHITE

	if _enemies_in_range.size() == 0:
		_target = null
	else:
		_target = _get_first_target(_enemies_in_range)


func _on_building_area_area_entered(area: Area2D) -> void:
	if active or area.owner is not Tower: return
	towers_in_range += 1


func _on_building_area_area_exited(area: Area2D) -> void:
	if active or area.owner is not Tower: return
	towers_in_range -= 1


func _on_building_area_mouse_entered() -> void:
	_is_mouse_on = true


func _on_building_area_mouse_exited() -> void:
	_is_mouse_on = false
#endregion
