extends PanelContainer
class_name TowerUI

#region Constants
const BULLETS_ICON = "res://Assets/Sprites/UI/bullets_icon.png"
const DAMAGE_ICON := "res://Assets/Sprites/UI/damage_icon.png"
const RADIUS_ICON := "res://Assets/Sprites/UI/radius_icon.png"
const COOLDOWN_ICON := "res://Assets/Sprites/UI/cooldown_icon.png"
const COIN_ICON := "res://Assets/Sprites/UI/Coin.png"

const UPGRADE_BUTTON = preload("res://Scenes/UI/upgrade_button.tscn")
#endregion

#region Variables
static var instance: TowerUI

@onready var tower_name_label: Label = $HBoxContainer/TowerName
@onready var tower_image_rect: TextureRect = $HBoxContainer/TowerImage
@onready var damage_label: RichTextLabel = $HBoxContainer/Damage
@onready var radius_label: RichTextLabel = $HBoxContainer/Radius
@onready var cooldown_label: RichTextLabel = $HBoxContainer/Cooldown
@onready var upgrade_buttons: HFlowContainer = $HBoxContainer/UpgradeButtons

var tower_instance : Tower
#endregion

#region Lifecycle Methods
func _ready() -> void:
	instance = self
	set_target(null)
#endregion

#region UI Update Methods
func set_target(tower : Tower) -> void:
	if tower_instance:
		tower_instance.fov_area_visualize.hide()
		tower_instance = null

	if tower == null:
		hide()
		return

	show()
	tower_instance = tower
	tower_instance.fov_area_visualize.show()

	var shop_tower_settings := tower.shop_tower_settings
	tower_name_label.text = shop_tower_settings.tower_name

	update_ui()


func update_ui() -> void:
	if tower_instance == null:
		return

	tower_instance.fov_collision.shape.radius = tower_instance.tower_settings.actual_radius
	tower_instance.fov_area_visualize.create_new_circle()

	var shop_tower_settings := tower_instance.shop_tower_settings
	var next_upgrades := shop_tower_settings.get_next_upgrades()

	if next_upgrades == null or next_upgrades.is_empty() and shop_tower_settings.current_upgrade:
		#print("Max level!")
		for button in upgrade_buttons.get_children():
			button.hide()
		
		next_upgrades = [shop_tower_settings.current_upgrade]
	else:
		var next_upgrades_size := next_upgrades.size()
		var upgrade_buttons_size := upgrade_buttons.get_child_count()
		if next_upgrades_size < upgrade_buttons_size:
			for i in range(next_upgrades_size - 1, upgrade_buttons_size):
				upgrade_buttons.get_child(i).hide()

		for i in next_upgrades_size:
			var button : UpgradeButton = null
			if i < upgrade_buttons_size: 
				button = upgrade_buttons.get_child(i)
			var upgrade := next_upgrades[i]
			create_button(upgrade, shop_tower_settings.display_tower_level, button)

	# Обновляем отображение картинки и подсказки кнопки улучшения
	tower_image_rect.texture = shop_tower_settings.tower_texture

	# Обновляем статистику башни
	update_tower_stats(tower_instance.tower_settings, null)
#endregion

#region Button Creation Methods
func create_button(upgrade: TowerUpgradeData, level: int, button_instance : UpgradeButton = null):
	if not button_instance: 
		button_instance = UPGRADE_BUTTON.instantiate()
		upgrade_buttons.add_child(button_instance)
	
	button_instance.initialize(upgrade, create_upgrade_description(upgrade, level))
	button_instance.show()

	if button_instance.pressed_upgrade.is_connected(_on_upgrade_button_pressed): return
	button_instance.pressed_upgrade.connect(_on_upgrade_button_pressed)


func create_upgrade_description(upgrade: TowerUpgradeData, level: int) -> String:
	var upgrade_description := generate_upgrade_description(upgrade)

	if not upgrade.upgrade_description.is_empty():
		upgrade_description += "\n" + "\n" + upgrade.upgrade_description

	var cost_text := "\n\n[color=orange][b]Cost:[/b] #cn %s[/color]" % str(upgrade.upgrade_cost.get_display_string())
	var upgrade_text := (("[b]level %s [/b]" % str(level)) + "[color=green][b]%s:[/b][/color] " % upgrade.upgrade_name) + upgrade_description
	return unparse_text(upgrade_text + cost_text)
#endregion

#region Upgrade Description Methods
func append_upgrade_description(upgrade_description: String, upg: TowerUpgradeStrategyBase, prefix: String) -> String:
	var current_v: String
	var next_v: String

	if upg is DamageUpgradeStrategy:
		current_v = tower_instance.tower_settings.get_display_damage()
		next_v = str(Math.floor_d(upg.add_v + upg.mult_v * tower_instance.tower_settings.get_damage().count.get_averange_count()))
	elif upg is CooldownUpgradeStrategy:
		current_v = tower_instance.tower_settings.cooldown.get_display_string()
		next_v = str(Math.floor_d(upg.add_v + upg.mult_v * tower_instance.tower_settings.cooldown.get_averange_count()))
	elif upg is RadiusUpgradeStrategy:
		current_v = tower_instance.tower_settings.radius.get_display_string()
		next_v = str(Math.floor_d(upg.add_v + upg.mult_v * tower_instance.tower_settings.radius.get_averange_count()))
	else:
		return upgrade_description + upg.changes_to_string() + "; "

	return upgrade_description + prefix + current_v + "->" + next_v + ", "


func generate_upgrade_description(upgrade: TowerUpgradeData) -> String:
	var upgrade_description: String = ""
	for i in range(upgrade.upgrades.size()):
		if i % 3 == 0:
			upgrade_description += "\n"

		var upg = upgrade.upgrades[i]
		if upg is DamageUpgradeStrategy:
			upgrade_description = append_upgrade_description(upgrade_description, upg, "#dmN ")
		elif upg is CooldownUpgradeStrategy:
			upgrade_description = append_upgrade_description(upgrade_description, upg, "#cdN ")
		elif upg is RadiusUpgradeStrategy:
			upgrade_description = append_upgrade_description(upgrade_description, upg, "#rdN ")
		else:
			upgrade_description += upg.changes_to_string() + "; "

	return upgrade_description
#endregion

#region Tower Stats Update Methods
func update_stat_label(label: RichTextLabel, stat_value: String, next_upgrade: TowerUpgradeStrategyBase, prefix: String):
	label.text = unparse_text(prefix + stat_value)
	if next_upgrade:
		label.set_text_of_tooltip(unparse_text(prefix + "N: " + stat_value + " " + next_upgrade.changes_to_string()))
	else:
		label.set_text_of_tooltip(unparse_text(prefix + "N") + ": " + stat_value)


func update_tower_stats(tower_settings: TowerSettings, next_upgrade: TowerUpgradeData):
	var damage := tower_settings.get_display_damage()
	var radius := tower_settings.radius.get_display_string()
	var cooldown := tower_settings.cooldown.get_display_string()
	var next_damage : DamageUpgradeStrategy
	var next_radius : RadiusUpgradeStrategy
	var next_cooldown : CooldownUpgradeStrategy

	if next_upgrade:
		next_damage = next_upgrade.get_upgrade_type_of("DamageUpgradeStrategy")
		next_radius = next_upgrade.get_upgrade_type_of("RadiusUpgradeStrategy")
		next_cooldown = next_upgrade.get_upgrade_type_of("CooldownUpgradeStrategy") 

	update_stat_label(damage_label, damage, next_damage, "#dm")
	update_stat_label(radius_label, radius, next_radius, "#rd")
	update_stat_label(cooldown_label, cooldown, next_cooldown, "#cd")
#endregion

#region Upgrade Button Press Handling
func _on_upgrade_button_pressed(upgrade: TowerUpgradeData) -> void:
	if tower_instance == null:
		return

	if upgrade == null:
		print("Can't upgrade: already at max level!")
		return

	if PlayerStats.instance.money < upgrade.upgrade_cost.get_count(): 
		print("Can't upgrade: not enough money!")
		return

	PlayerStats.instance.remove_money(upgrade.upgrade_cost.get_count())
	upgrade.apply_upgrades(tower_instance)
	#print("Upgraded to " + str(tower_instance.shop_tower_settings.display_tower_level))

	update_ui()
#endregion

#region Text Unparsing
## Unparses text with keys
## (#dm - damage
## #cd - cooldown
## #rd - radius
## #cn - coin
## #bt - bullet
## #??N - image with name)
## to images ['img]key['/img] key
func unparse_text(text: String) -> String:
	var parts := text.split("#")
	var result := ""
	for i in parts:
		var temp_part := i
		var is_damage := temp_part.begins_with("dm")
		var is_cooldown := temp_part.begins_with("cd")
		var is_radius := temp_part.begins_with("rd")
		var is_coin := temp_part.begins_with("cn")
		var is_bullets := temp_part.begins_with("bt")
		var is_any := is_radius or is_cooldown or is_damage or is_coin or is_bullets
		if is_any:
			temp_part = temp_part.erase(0, 2)
			var with_name := temp_part.begins_with("N")
			if with_name: temp_part = temp_part.erase(0)
			
			var path := ""
			var name_part := ""
			if is_damage:
				path = DAMAGE_ICON
				if with_name: name_part = " Damage"
			elif is_cooldown:
				path = COOLDOWN_ICON
				if with_name: name_part = " Cooldown"
			elif is_radius:
				path = RADIUS_ICON
				if with_name: name_part = " Radius"
			elif is_coin:
				path = COIN_ICON
				if with_name: name_part = " Coin"
			elif is_bullets:
				path = BULLETS_ICON
				if with_name: name_part = " Bullets"
			temp_part = ("[img]%s[/img]" % path) + name_part + temp_part
		result += temp_part
	return result.strip_edges()
#endregion

#region Input Handling
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		set_target(null)
#endregion
