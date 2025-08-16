extends TooltipInteract
class_name UpgradeButton

signal pressed_upgrade(upgrade: TowerUpgradeData)

@onready var texture_rect: TextureRect = $TextureRect
var upgrade: TowerUpgradeData

func initialize(button_upgrade: TowerUpgradeData, text_of_tooltip: String) -> void:
	upgrade = button_upgrade
	texture_rect.texture = upgrade.upgrade_image
	set_text_of_tooltip(text_of_tooltip)


func _on_pressed() -> void:
	pressed_upgrade.emit(upgrade)
