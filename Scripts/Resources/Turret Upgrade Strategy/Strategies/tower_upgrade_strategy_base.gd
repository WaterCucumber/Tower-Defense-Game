extends Resource
class_name TowerUpgradeStrategyBase

func apply_upgrade(_tower: Tower):
	printerr("Empty upgrade!")


func match_id(_temp_id: String) -> bool:
	return false


func changes_to_string() -> String:
	return ""
