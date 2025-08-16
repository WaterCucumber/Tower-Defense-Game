extends TowerUpgradeData
class_name MeleeTowerUpgradeData

@export var upgraded_tower_weapon : Texture2D

func apply_upgrades(tower: Tower):
	super.apply_upgrades(tower)
	tower.sword.texture = upgraded_tower_weapon
