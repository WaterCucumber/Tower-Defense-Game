extends Resource
class_name TowerUpgradeData

@export var upgrade_name := ""
@export_multiline var upgrade_description := ""
@export var upgrade_image : Texture2D

@export var upgrade_cost : CountBase
@export var upgrades : Array[TowerUpgradeStrategyBase]

@export var next_upgrades : Array[TowerUpgradeData]

func apply_upgrades(tower: Tower):
	for i in upgrades:
		#print("Apply upgrade ", i)
		i.apply_upgrade(tower)
	tower.shop_tower_settings.next_upgrades = next_upgrades
	tower.shop_tower_settings.current_upgrade = self
	tower.shop_tower_settings.display_tower_level += 1


func get_upgrade_type_of(type: String):
	for i in upgrades:
		if i.match_id(type):
			return i
	return null
