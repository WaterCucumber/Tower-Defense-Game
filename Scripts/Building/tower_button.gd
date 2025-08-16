extends Button

const SNAP_STEP := 16
const SNAP_OFFSET := Vector2.ONE * 8

const VALID_PLACE_COLOR := Color.WEB_GREEN - Color(0,0,0,0.5)
const INVALID_PLACE_COLOR := Color.FIREBRICK - Color(0,0,0,0.5)

@export var shop_tower_settings : ShopTowerSettings

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var cost_label: Label = $VBoxContainer/Cost/CostLabel
@onready var tower_image: TextureRect = $VBoxContainer/TowerImage
@onready var placement: HBoxContainer = $VBoxContainer/Placement

var current_shop_tower_settings : ShopTowerSettings
var current_tower : Tower
var can_place := false

func _ready() -> void:
	initialize(shop_tower_settings)


func initialize(settings : ShopTowerSettings) -> void:
	if not settings: return
	current_shop_tower_settings = settings
	name_label.text = settings.tower_name
	cost_label.text = str(settings.tower_cost)
	tower_image.texture = settings.tower_texture

	for i in settings.place_tiles:
		var texture_rect := TextureRect.new()
		texture_rect.texture = BuildManager.instance.tile_dict[i]
		texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		texture_rect.stretch_mode = TextureRect.STRETCH_TILE
		get_parent().queue_redraw()
		placement.add_child(texture_rect)


func _on_pressed() -> void:
	if current_shop_tower_settings:
		if current_tower != null:
			current_tower.queue_free()
			current_tower = null
		var tower : Tower = current_shop_tower_settings.tower_settings._get_tower_scene().instantiate()
		current_tower = tower
		get_tree().root.add_child(current_tower)
		current_tower.initialize(current_shop_tower_settings.tower_settings)
		current_tower.show_area()


func _process(_delta: float) -> void:
	if current_tower:
		var mp := snap_to_grid(current_tower.get_global_mouse_position())
		current_tower.global_position = mp

		var tile_data : BuildManager.LevelTileData = BuildManager.instance.get_tile_at_global_position(mp)
		can_place = _can_place(tile_data)
		current_tower.modulate = VALID_PLACE_COLOR if can_place else INVALID_PLACE_COLOR

		#print(shop_tower_settings.tower_name, " moving at ", mp, " data: ", tile_type)


func _input(event: InputEvent) -> void:
	if current_tower:
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				var mp := snap_to_grid(current_tower.get_global_mouse_position())
				current_tower.global_position = mp

				var tile_data : BuildManager.LevelTileData = BuildManager.instance.get_tile_at_global_position(mp)
				can_place = _can_place(tile_data)
				current_tower.modulate = Color.WHITE if can_place else INVALID_PLACE_COLOR

				if not can_place:
					#var tower_name := current_shop_tower_settings.tower_name
					#var causes := ""
					## Hasn't current_tower or current_tower is colliding some towers
					#if not current_tower.can_place:
						#causes += ("collision (" + str(current_tower.towers_in_range)
								#+ " tower" + ("s" if current_tower.towers_in_range > 1 else "")
								#+ "); ")
					## Can't place current_tower to tile_to_place
					#if not current_shop_tower_settings.place_tiles.has(tile_data.type):
						#causes += "invalid position (" + str(mp) + " data: " + str(tile_data) + "); "
					## Hasn't enough money
					#if PlayerStats.instance.money < current_shop_tower_settings.tower_cost:
						#causes += ("not enough money (" + str(PlayerStats.instance.money) 
								#+ "/" +str(current_shop_tower_settings.tower_cost) 
								#+ "); ")
					#print("Can't place tower ", tower_name, " because " + causes)
					return

				current_tower.activate(current_shop_tower_settings, tile_data.buff)
				current_tower.hide_area()
				current_tower = null

				BuildManager.instance.tiles_with_turret.append(tile_data.map_position)

				PlayerStats.instance.remove_money(current_shop_tower_settings.tower_cost)
				#print(shop_tower_settings.tower_name, " placed (data: ", tile_data, ")")
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				current_tower.queue_free()
				current_tower = null
				#print(shop_tower_settings.tower_name, " placement has been cancelled")


func snap_to_grid(pos: Vector2, step := SNAP_STEP, offset := SNAP_OFFSET) -> Vector2:
	return (pos + offset).snappedf(step) - offset


func _can_place(tile_to_place: BuildManager.LevelTileData) -> bool:
	# Hasn't current_tower or current_tower is colliding some towers
	if (not (current_tower and current_tower.can_place) 
			or BuildManager.instance.tiles_with_turret.has(tile_to_place.map_position)): return false
	# Can't place current_tower to tile_to_place
	if not current_shop_tower_settings.place_tiles.has(tile_to_place.type):
		return false
	# Hasn't enough money
	if PlayerStats.instance.money < current_shop_tower_settings.tower_cost:
		return false

	return BuildManager.instance.can_place_tower


func _on_mouse_entered() -> void:
	BuildManager.instance.can_place_tower = false


func _on_mouse_exited() -> void:
	BuildManager.instance.can_place_tower = true
