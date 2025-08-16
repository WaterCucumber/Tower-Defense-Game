extends Node2D


func _on_explosion_animation_finished() -> void:
	queue_free()
