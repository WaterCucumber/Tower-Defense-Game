@icon("res://Assets/Node Icons/SupportTowerSettings.png")
extends RangedTowerSettings
class_name SupportTowerSettings

const SUPPORT_TURRET = preload("res://Scenes/Objects/Turrets/support_turret.tscn")

@export var damage_buff : CountBase
@export var range_buff : CountBase
@export var fire_rate_buff : CountBase


func _get_tower_scene() -> PackedScene:
	var result := super._get_tower_scene()
	if result != RANGED_TURRET and result != null:
		return result
	return SUPPORT_TURRET
