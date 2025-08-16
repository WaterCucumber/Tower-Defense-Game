extends TowerUpgradeData
class_name RangedTowerUpgradeData

@export var upgraded_tower_attack : AnimationTextures

func apply_upgrades(tower: Tower):
	super.apply_upgrades(tower)
	tower.tower_settings.attack_anim = upgraded_tower_attack
	tower._initialize_animation(tower.tower_settings)
