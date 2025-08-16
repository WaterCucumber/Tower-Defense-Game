@icon("res://Assets/Node Icons/TowerSettings.png")
extends Resource
class_name TowerSettings

const RADIUS_MULTIPLIER := 10

@export var use_custom_tower_scene := false
@export var tower_scene : PackedScene
@export_group("Stats")
@export var radius : CountBase
@export var cooldown : CountBase

## Turret shoots to offsetted enemy's position. Use OffsetType.BEST for the best shooting
@export var offset_type := Tower.OffsetType.BETTER
## Draws red circle at position and red line to
@export var debug_target_pos := false
@export_group("Visualization")
@export var attack_anim : AnimationTextures
@export var weapon_size := Vector2.ONE


var actual_radius :
	get():
		return radius.get_count() * RADIUS_MULTIPLIER


func get_damage() -> BaseDamage:
	return null


func set_damage(_v: BaseDamage) -> void:
	pass


func get_display_damage() -> String:
	if not get_damage(): return "N/A"

	var count := get_damage().count
	if count is RandomCount:
		return (str(Math.floor_d(count.min_count.get_averange_count())) 
				+ "-" + str(Math.floor_d(count.max_count.get_averange_count())))
	return str(Math.floor_d(count.get_count()))


func _get_tower_scene() -> PackedScene:
	if use_custom_tower_scene:
		return tower_scene
	else:
		return null
