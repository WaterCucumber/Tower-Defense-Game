extends CountUpgradeStrategy
class_name RadiusUpgradeStrategy

func apply_upgrade(tower: Tower):
	#print("Radius before upgrade: ", tower.tower_settings.radius.get_display_string())
	var radius := tower.tower_settings.radius
	radius.increase(mult_v)
	radius.add(add_v)
	#print("Radius after upgrade: ", tower.tower_settings.radius.get_display_string())


func match_id(temp_id: String) -> bool:
	return temp_id == "RadiusUpgradeStrategy"


func changes_to_string() -> String:
	return "#rdN " + super.changes_to_string()
