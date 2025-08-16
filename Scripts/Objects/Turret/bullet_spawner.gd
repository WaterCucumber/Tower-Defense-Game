extends Node2D
class_name BulletSpawner

signal shoot(bullet: Bullet)

const BULLET := preload("res://Scenes/Objects/bullet.tscn")

@export_group("Bullet Spawner")
var speed := 300.0
@export var bullet_settings := BulletSettings.new()
@export var spawn_interval : CountBase
@export var active := true

@onready var center_pos = Vector2.ZERO

var spawn_timer: Timer
var spawn_i := 0


func enable():
	active = true


func disable():
	active = false


func _ready():
	# Запускаем таймер для спавна пуль
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval.get_count()
	spawn_timer.one_shot = true
	spawn_timer.autostart = false
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func _process(_delta: float) -> void:
	if active:
		if spawn_interval is not RandomCount:
			if (spawn_interval != null 
					and spawn_timer.wait_time != spawn_interval.get_count()):
				spawn_timer.wait_time = spawn_interval.get_count()
	visible = active
	if Engine.is_editor_hint():
		queue_redraw()
		return


func _on_spawn_timer_timeout():
	if active:
		spawn_timer.wait_time = spawn_interval.get_count()
		spawn_i += 1


func _spawn_bullet_process(_target: Node2D):
	pass


func spawn_bullet(pos: Vector2, rot: float, dir: Vector2, _target: Node2D) -> Bullet:
	var bullet := BULLET.instantiate()
	bullet.rotation = rot
	bullet.position = pos + global_position

	get_tree().root.call_deferred("add_child", bullet)
	bullet.call_deferred('initialize', bullet_settings, self)

	if bullet.has_method("set_direction"):
		bullet.set_direction(dir)

	shoot.emit(bullet)
	return bullet


func multiply_interval(v: float):
	spawn_interval.increase(v)
	spawn_timer.wait_time = spawn_interval.get_count()
