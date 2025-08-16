extends CharacterBody2D
class_name Bullet

const EXPLOSION = preload("res://Scenes/Effects/explosion.tscn")
const SPEED_MULTIPLIER := 50

@onready var attack_component: AttackComponent = $AttackComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $HitboxComponent/CollisionShape2D
@onready var body_collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var effect_applier_component: EffectApplierComponent = $EffectApplierComponent

var life_timer: Timer

var Velocity := Vector2.ZERO

var bounce_count := 0
var _settings: BulletSettings
var source : Node2D
var enemy_pierce := 0

var initialized := false

func initialize(settings: BulletSettings, _source: Node2D):
	source = _source
	animated_sprite_2d.sprite_frames = SpriteFrames.new()
	_settings = settings.duplicate(true)
	hitbox_component.collision_mask = _settings.bullet_collision_mask
	attack_component.damage = _settings.damage

	hitbox_component.attacked.connect(_on_bullet_attacked)

	life_timer = Timer.new()
	life_timer.wait_time = _settings.lifetime
	life_timer.one_shot = true
	life_timer.autostart = true
	life_timer.timeout.connect(_on_life_timer_timeout)
	add_child(life_timer)

	var animation_name = "default"
	var sprite_frames := _settings.bullet_animation
	var use_average := _settings.hitbox_size == Vector2.ZERO
	var averange_texture_size : Vector2
	var sum_size := Vector2.ZERO
	for i in sprite_frames:
		animated_sprite_2d.sprite_frames.add_frame(animation_name, i)
		if use_average : sum_size += i.get_size()

	if use_average : 
		averange_texture_size = sum_size / sprite_frames.size() 
		_settings.hitbox_size = averange_texture_size

	animated_sprite_2d.scale = _settings.bullet_size
	animated_sprite_2d.modulate = _settings.sprite_modulate
	animated_sprite_2d.play(animation_name)

	var size := _settings.bullet_size * _settings.hitbox_size
	collision_shape.call_deferred("set_shape", RectangleShape2D.new())
	body_collision_shape.call_deferred("set_shape", RectangleShape2D.new())
	collision_shape.shape.size = size
	body_collision_shape.shape.size = size

	var rect_x := -size.x / 2
	var rect_y := -size.y / 2
	visible_on_screen_notifier.rect = Rect2(rect_x, rect_y,
			size.x, size.y)

	if _settings.bullet_effect:
		effect_applier_component.effect = _settings.bullet_effect

	initialized = true


func set_direction(dir: Vector2):
	Velocity = dir.normalized()


func _physics_process(delta: float) -> void:
	if not initialized: return
	velocity = Velocity * _settings.bullet_speed.get_speed(_settings.lifetime,
			life_timer.time_left) * SPEED_MULTIPLIER * delta
	velocity += _settings.bullet_trajectory_settings.get_offset(
		life_timer.time_left).rotated(rotation)

	var collision_info := move_and_collide(velocity * delta)
	if collision_info:
		if bounce_count >= _settings.max_bounce:
			play_effect()
			#print("End")
			queue_free()
			return
		var norm := collision_info.get_normal()
		Velocity = Velocity.bounce(norm)
		rotation = Velocity.angle()
		velocity *= 0.75
		bounce_count += 1


func play_effect():
	if _settings.impact_effect:
		var effect := _settings.impact_effect.instantiate()
		get_tree().root.add_child(effect)
		effect.global_position = global_position
		effect.scale *= 0.5 * _settings.bullet_size


func _on_bullet_attacked(_hurtbox: HurtboxComponent, _d):
	if enemy_pierce >= _settings.pierce:
		play_effect()
		queue_free()
	else:
		enemy_pierce += 1


func _on_life_timer_timeout() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#print("_on_visible_on_screen_notifier_2d_screen_exited End")
	queue_free()


func _on_hitbox_component_attacked(_object: HurtboxComponent, _damage: Variant) -> void:
	queue_free()
