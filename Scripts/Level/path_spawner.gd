extends Node2D
class_name PathSpawner

@export var path: Path2D
@onready var path_visual: Line2D = $"PathVisual"
#var _path := preload("res://Scenes/Levels/level_1.tscn")

func _ready() -> void:
	var curve := path.curve
	for i in curve.point_count:
		path_visual.add_point(curve.get_point_position(i))
