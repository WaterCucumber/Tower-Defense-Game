extends CountUpgradeStrategy
class_name DamageUpgradeStrategy


func apply_upgrade(tower: Tower):
	#print("Damage before upgrade: ", tower.tower_settings.get_display_damage())
	var damage := tower.tower_settings.get_damage()
	damage.count.increase(mult_v)
	damage.count.add(add_v)
	#print("Damage after upgrade: ", tower.tower_settings.get_display_damage())


func match_id(temp_id: String) -> bool:
	return temp_id == "DamageUpgradeStrategy"


func changes_to_string() -> String:
	return "#dmN " + super.changes_to_string()
