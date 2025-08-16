extends Node2D

@export var valid_color := Color.WEB_GREEN
@export var invalid_color := Color.PALE_VIOLET_RED

@onready var fov_area_visualizer: CircleVisualizer = $"FOV Area Visualize"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var selected_tower : Tower

func select(tower: Tower):
	fov_area_visualizer.shape = tower.fov_collision
	fov_area_visualizer.create_new_circle()

	selected_tower = tower


func set_valid(valid: bool):
	modulate = valid_color if valid else invalid_color


func _add_frames(anim_name: String, textures: Array[Texture2D], is_looping := true, fps := 10.0) -> void:
	animated_sprite.sprite_frames.add_animation(anim_name)
	animated_sprite.sprite_frames.set_animation_loop(anim_name, is_looping)
	animated_sprite.sprite_frames.set_animation_speed(anim_name, fps)
	for tex in textures:
		animated_sprite.sprite_frames.add_frame(anim_name, tex)
