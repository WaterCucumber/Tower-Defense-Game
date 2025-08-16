@icon("res://Assets/Node Icons/MeleeTowerSettings.png")
extends TowerSettings
class_name MeleeTowerSettings

const MELEE_TURRET = preload("res://Scenes/Objects/Turrets/melee_turret.tscn")

@export_custom(PROPERTY_HINT_RANGE, "-180,180,or_greater,or_less") var swing_rotating := Vector2(-45, 45)
@export var swing_time := 0.5
@export var damage: BaseDamage
@export var weapon_texture : Texture2D

func _get_tower_scene() -> PackedScene:
	var result := super._get_tower_scene()
	if result != null:
		return result
	return MELEE_TURRET


func get_damage() -> BaseDamage:
	return damage


func set_damage(v: BaseDamage) -> void:
	damage = v
