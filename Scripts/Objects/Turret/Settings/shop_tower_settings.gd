@icon("res://Assets/Node Icons/ShopTowerSettings.png")
extends Resource
class_name ShopTowerSettings

@export var tower_texture : Texture2D
@export var tower_name := ""
@export var tower_cost := 1.0
@export var tower_sell_pct := 0.95
@export var place_tiles : Array[BuildManager.TileType] = [BuildManager.TileType.GRASS]

@export var tower_settings : TowerSettings
@export var tower_upgrades : Array[TowerUpgradeData]

var current_upgrade : TowerUpgradeData
var next_upgrades : Array[TowerUpgradeData]

var display_tower_level := 0

func get_next_upgrades(return_last_on_null := false) -> Array[TowerUpgradeData]:
	if not next_upgrades or next_upgrades.is_empty():
		#print("Next upgrades is null")
		if display_tower_level == 0:
			#print("Retrun tower upgrades: ", tower_upgrades)
			return tower_upgrades
		if return_last_on_null: 
			return [current_upgrade]
	#print("Next upgrades IS NOT null")
	return next_upgrades
