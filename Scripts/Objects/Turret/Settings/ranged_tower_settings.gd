@icon("res://Assets/Node Icons/RangeTowerSettings.png")
extends TowerSettings
class_name RangedTowerSettings

const RANGED_TURRET = preload("res://Scenes/Objects/Turrets/ranged_turret.tscn")

@export var spread : CountBase
@export var bullet_count : CountBase
@export var bullet_settings : BulletSettings

var display_damage : String :
	get():
		var dmg := bullet_settings.damage.count
		if dmg is RandomCount:
			return str(dmg.min_count) + "-" + str(dmg.max_count)
		return str(dmg.get_count())


func _get_tower_scene() -> PackedScene:
	var result := super._get_tower_scene()
	if result != null:
		return result
	return RANGED_TURRET


func get_damage() -> BaseDamage:
	return bullet_settings.damage


func set_damage(v: BaseDamage) -> void:
	bullet_settings.damage = v
