extends BaseTurretEffect
class_name FireRateTurretEffect

@export var multiplier := 0.8

func apply_effect(tower: Tower):
	tower.tower_settings.cooldown.increase(multiplier)
	tower.buffs.append(self)
