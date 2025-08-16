extends CountUpgradeStrategy
class_name CooldownUpgradeStrategy


func apply_upgrade(tower: Tower):
	#print("Cooldown before upgrade: ", tower.tower_settings.cooldown.get_display_string())
	var cooldown := tower.tower_settings.cooldown
	cooldown.increase(mult_v)
	cooldown.add(add_v)
	#print("Cooldown after upgrade: ", tower.tower_settings.cooldown.get_display_string())


func match_id(temp_id: String) -> bool:
	return temp_id == "CooldownUpgradeStrategy"


func changes_to_string() -> String:
	return "#cdN " + super.changes_to_string()
