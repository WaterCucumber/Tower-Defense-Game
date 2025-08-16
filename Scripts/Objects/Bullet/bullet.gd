extends Node2D
#class_name Bullet

@export var bullet_texture : Texture2D
@export var homing := false
## Bullet won't home while not travelled that distance (time=this/speed)
@export var pixels_before_homing := 50.0
var start_homing := false

var _velocity := Vector2.ZERO
var _target : Node2D
var _speed := 0.0

func _ready() -> void:
	$Bullet.texture = bullet_texture
	var size := Vector2(bullet_texture.get_height(), bullet_texture.get_width())
	$HitboxComponent/CollisionShape2D.shape.size = size


func initialize(velocity: Vector2, speed: float, target: Node2D):
	_speed = speed
	if homing: 
		var timer := Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.wait_time = pixels_before_homing / _speed
		timer.timeout.connect(func(): start_homing = true)
		add_child(timer)
		_target = target
	_velocity = velocity * _speed
	rotation = _velocity.angle()


func _process(delta: float) -> void:
	if start_homing and _target:
		# Homing
		look_at(_target.global_position)
		global_position += global_position.direction_to(_target.global_position) * _speed * delta
	else:
		# Basic
		global_position += _velocity * delta


func _on_hitbox_component_attacked(_object: HurtboxComponent, _damage: Variant) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
