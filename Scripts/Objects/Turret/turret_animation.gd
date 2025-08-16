extends Node

signal attack_animation_finished

@export var attack_anim : AnimationTextures
@export var post_attack_anim : AnimationTextures

@onready var animated_sprite: AnimatedSprite2D = $"../Animation/AnimatedSprite2D"

func initialize(fps := 10.0) -> void:
	animated_sprite.sprite_frames = SpriteFrames.new()

	_add_frames("attack", attack_anim.textures, false, fps)
	_add_frames("post_attack", [], false, fps)
	animated_sprite.play("attack")

	if animated_sprite.animation_finished.is_connected(_on_animation_finished): return
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _add_frames(anim_name: String, textures: Array[Texture2D], is_looping := false, fps := 10.0) -> void:
	animated_sprite.sprite_frames.add_animation(anim_name)
	animated_sprite.sprite_frames.set_animation_loop(anim_name, is_looping)
	animated_sprite.sprite_frames.set_animation_speed(anim_name, fps)
	for tex in textures:
		animated_sprite.sprite_frames.add_frame(anim_name, tex)


func _on_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		attack_animation_finished.emit()
	elif animated_sprite.animation == "post_attack":
		animated_sprite.play("attack")
