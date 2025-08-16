extends Node

@export var movement_anim: AnimationTextures
@export var death_anim: AnimationTextures
@export var effect_anim_tex: AnimationTextures

@onready var main_anim: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var effect_anim: AnimatedSprite2D = $"../Effect"

var animation_library: AnimationLibrary

func initialize():
	# Создаём SpriteFrames для AnimatedSprite2D
	main_anim.sprite_frames = SpriteFrames.new()
	_add_frames(main_anim, "movement", movement_anim.textures, true)
	_add_frames(main_anim, "death", death_anim.textures)

	if effect_anim_tex: 
		effect_anim.sprite_frames = SpriteFrames.new()
		_add_frames(effect_anim, "effect", effect_anim_tex.textures, true)
		effect_anim.play("effect")

	main_anim.play("movement")
	main_anim.animation_finished.connect(_on_animation_finished)
	health_component.died.connect(func(): main_anim.play("death"))


func _add_frames(animated_sprite: AnimatedSprite2D, anim_name: String, textures: Array[Texture2D], is_looping := false, fps := 10.0) -> void:
	animated_sprite.sprite_frames.add_animation(anim_name)
	animated_sprite.sprite_frames.set_animation_loop(anim_name, is_looping)
	animated_sprite.sprite_frames.set_animation_speed(anim_name, fps)
	for tex in textures:
		animated_sprite.sprite_frames.add_frame(anim_name, tex)


func _on_animation_finished() -> void:
	if main_anim.animation == "death":
		owner.call_deferred("queue_free")
