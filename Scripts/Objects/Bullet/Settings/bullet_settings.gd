extends Resource
class_name BulletSettings

@export var max_bounce: int = 0
@export var damage: BaseDamage
@export var lifetime: float = 5.0
@export var pierce: int = 0

@export_group("Settings")
@export var bullet_speed := BulletSpeedSettings.new()
@export var bullet_trajectory_settings := BulletTrajectorySettings.new()
@export var bullet_effect : Effect
@export_custom(PROPERTY_HINT_LAYERS_2D_PHYSICS, "") var bullet_collision_mask : int = 1
@export_group("Visual")
@export var bullet_animation : Array[Texture2D]
@export var bullet_scale : CountBase = Count.new()
@export var hitbox_size := Vector2.ZERO
@export var sprite_modulate := Color.WHITE
@export var impact_effect : PackedScene

var bullet_size : Vector2 : 
	get(): return Vector2.ONE * bullet_scale.get_count()
