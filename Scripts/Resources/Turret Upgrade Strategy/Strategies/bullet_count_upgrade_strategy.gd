extends CountUpgradeStrategy
class_name BulletCountUpgradeStrategy

func apply_upgrade(tower: Tower):
	var settings := tower.tower_settings
	if settings is RangedTowerSettings:
		var bullet_count : CountBase = settings.bullet_count
		if not bullet_count:
			var spread : CountBase = settings.spread
			if not spread:
				spread = Count.new()
				spread.count = 30
				settings.spread = spread
			bullet_count = Count.new()
			bullet_count.count = 1
			settings.bullet_count = bullet_count

		bullet_count.increase(mult_v)
		bullet_count.add(add_v)
	else:
		printerr("Can't apply upgrade: apply only for RangedTowerSettings or childs of RangedTowerSettings")


func match_id(temp_id: String) -> bool:
	return temp_id == "BulletCountUpgradeStrategy"


func changes_to_string() -> String:
	return "#btN " + super.changes_to_string()
