@icon("res://Assets/Node Icons/SupportTurret.png")
extends RangedTower
class_name SupportTower

var towers_to_buff : Array[Tower] = []


func apply_buffs_to_towers(towers: Tower):
	for i in towers:
		i.co


func _on_fov_area_area_entered(area: Area2D) -> void:
	if area.owner is Enemy: 
		super._on_fov_area_area_entered(area)
		return

	if area.owner is not Tower: return

	towers_to_buff.append(area.owner)
	if tower_settings and tower_settings.debug_target_pos: area.owner.modulate = Color.RED


func _on_fov_area_area_exited(area: Area2D) -> void:
	if area.owner is Enemy: 
		super._on_fov_area_area_exited(area)
		return

	if area.owner is not Tower: return

	area.owner.modulate = Color.WHITE
	towers_to_buff.erase(area.owner)
