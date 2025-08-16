extends Node2D

signal reached_end

@export var speed := 100.0
@onready var path_follow : PathFollow2D = owner
@onready var path : Path2D = path_follow.get_parent()
@onready var health_component: HealthComponent = $"../HealthComponent"

var already_reached_end := false
var delta_move := Vector2.ZERO
var previous_position := Vector2.ZERO

func get_next_position(next_time := 1.0) -> Vector2:
	var curve_length = path.curve.get_baked_length()
	# Вычисляем новое расстояние с учетом скорости и времени
	var next_distance = path_follow.progress + speed * next_time
	# Ограничиваем значение, чтобы не выйти за длину кривой (если нужно)
	next_distance = clamp(next_distance, 0, curve_length)
	# Получаем позицию на кривой по расстоянию
	var sample_pos = path.curve.sample_baked(next_distance)
	return sample_pos


func _ready() -> void:
	health_component.died.connect(func(): speed = 0)


func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	delta_move = global_position - previous_position
	previous_position = global_position
	if path_follow.progress_ratio == 1 and not already_reached_end:
		already_reached_end = true
		reached_end.emit()
