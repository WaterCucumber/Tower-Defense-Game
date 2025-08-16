#@tool
extends Node2D

const SOURCE_ID := 0

enum TileType {NONE, GRASS, ROCK, WATER, LAVA, PATH}

@export var path_2d: Path2D
@export var level_size := Vector2i(26, 16)
@export var effect_places_count := 40
@export var invert_rock_noise := false
@export var rock_noise : FastNoiseLite
@export_range(0, 1) var lava_density := 0.3 # регулирует сколько лавы внутри камня
@export_range(0, 1) var rock_threshold := 0.75
@export var invert_water_noise := false
@export var water_noise : FastNoiseLite
@export_range(0, 1) var water_threshold := 0.5
#@export_tool_button("Generate") var gen := generate
#@export_tool_button("Clear") var cl := clear

@onready var grass_layer: TileMapLayer = $GrassLayer
@onready var rock_layer: TileMapLayer = $RockLayer
@onready var water_layer: TileMapLayer = $WaterLayer
@onready var lava_layer: TileMapLayer = $LavaLayer
@onready var path_layer: TileMapLayer = $PathLayer
@onready var buff_layer: TileMapLayer = $BuffLayer
@onready var other_layers: TileMapLayer = $OtherLayers

var tile_dict: Dictionary[TileType, Array] = {
	TileType.LAVA: [Vector2(0, 1)],
	TileType.ROCK: [Vector2(1, 1), Vector2(5, 1), Vector2(9, 1)],
	TileType.GRASS: [Vector2(2, 1), Vector2(6, 1), Vector2(10, 1)],
	TileType.WATER: [Vector2(3, 1)],
}


var path_alt_tile_dict: Dictionary[TileType, Array] = {
	TileType.LAVA: [Vector2(0, 0)],
	TileType.ROCK: [Vector2(1, 0), Vector2(5, 0), Vector2(9, 0)],
	TileType.GRASS: [Vector2(2, 0), Vector2(6, 0), Vector2(10, 0)],
	TileType.WATER: [Vector2(3, 0)],
}

@onready var layers := [grass_layer, rock_layer, water_layer, lava_layer, path_layer]
@onready var all_layers := [grass_layer, rock_layer, water_layer, lava_layer, path_layer, buff_layer, other_layers]

func _ready() -> void:
	generate()
	
	for i in path_2d.curve.get_baked_points():
		set_cell(path_layer.local_to_map(path_layer.to_local(i)), TileType.PATH)
	
	var quater := effect_places_count / 4.0
	for i in [grass_layer, rock_layer, water_layer, lava_layer]:
		var positions : Array[Vector2i]
		positions.append_array(i.get_used_cells())
		positions.shuffle()
		#print(i.name, " has total positions: ", positions.size(), 
				#", buff positions: ", mini(positions.size(), quater))
		for j in quater:
			if positions.size() <= j: break
			var pos := positions[j]
			#print("Buff placed at ", i.name, " ", pos)
			var effect : Vector2i = (BuildManager.instance.
					tile_effect_dict.keys().pick_random())
			buff_layer.set_cell(pos, SOURCE_ID, effect)
	
	var build_manager : BuildManager = BuildManager.instance
	if not build_manager: return
	
	build_manager.grass_layer = grass_layer
	build_manager.rock_layer = rock_layer
	build_manager.water_layer = water_layer
	build_manager.lava_layer = lava_layer
	build_manager.path_layer = path_layer
	build_manager.buff_layer = buff_layer


func save_to_json(path_to_json: String):
	var cells := {}

	for layer in all_layers:
		for cell_pos in layer.get_used_cells():
			cells[layer.name][str(cell_pos)] = layer.get_cell_atlas_coords(cell_pos)
	JsonParser.save_to_json(cells, path_to_json)


func load_from_json(path_to_json: String):
	var cells := JsonParser.load_from_json(path_to_json)

	for layer in all_layers:
		layer.clear()
		var cell_coords : Dictionary = cells.get_or_add(layer.name, [])
		for i in cell_coords.size():
			var coord = cell_coords.keys()[i]
			var atlas_coord = cell_coords.values()[i]
			layer.set_cell(coord, SOURCE_ID, atlas_coord)


func randomize_seeds():
	rock_noise.seed = randi()
	water_noise.seed = randi()


func generate() -> void:
	clear()
	randomize_seeds()
	create_rocks()
	create_lava_inside_rocks()
	fill_water_and_grass()


func create_rocks() -> void:
	for x in range(level_size.x):
		for y in range(level_size.y):
			var pos = Vector2(x, y)
			var rock_noise_value = rock_noise.get_noise_2d(x, y)
			if invert_rock_noise:
				rock_noise_value = 1 - rock_noise_value
			
			if rock_noise_value >= rock_threshold:
				set_cell(pos, TileType.ROCK)
			else:
				erase_all_layers_at(pos)


func create_lava_inside_rocks() -> void:
	for x in range(level_size.x):
		for y in range(level_size.y):
			var pos = Vector2(x, y)
			if has_tile(rock_layer, pos):
				# С вероятностью lava_density пытаемся поставить лаву
				if randf() < lava_density:
					# Проверяем окружение: 8 соседей (или 4) — все должны быть камнем или лавой
					if _is_surrounded_by_rock_or_lava(pos):
						set_cell(pos, TileType.LAVA)


func _is_surrounded_by_rock_or_lava(pos: Vector2) -> bool:
	var offsets = [
		Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1,  0),               Vector2(1,  0),
		Vector2(-1,  1), Vector2(0,  1), Vector2(1,  1),
	]
	for offset in offsets:
		var neighbor_pos = pos + offset
		# Проверяем, что сосед в пределах карты
		if neighbor_pos.x < 0 or neighbor_pos.x >= level_size.x:
			return false
		if neighbor_pos.y < 0 or neighbor_pos.y >= level_size.y:
			return false
		# Если сосед не камень и не лава — возвращаем false
		if not (has_tile(rock_layer, neighbor_pos) or has_tile(lava_layer, neighbor_pos)):
			return false
	return true


func fill_water_and_grass() -> void:
	for x in range(level_size.x):
		for y in range(level_size.y):
			var pos = Vector2(x, y)
			if has_tile(rock_layer, pos) or has_tile(lava_layer, pos):
				continue
			
			var water_noise_value = water_noise.get_noise_2d(x, y)
			if invert_water_noise:
				water_noise_value = 1 - water_noise_value
				
			if water_noise_value >= water_threshold:
				set_cell(pos, TileType.WATER)
			else:
				set_cell(pos, TileType.GRASS)


func erase_all_layers_at(pos: Vector2) -> void:
	for layer in layers:
		if has_tile(layer, pos):
			layer.erase_cell(pos)


func _get_random_tile(type: TileType, path := false) -> Vector2:
	var options = (path_alt_tile_dict if path else tile_dict).get(type, [])
	if options.size() == 0:
		return Vector2.ZERO
	return options.pick_random()


func clear():
	for x in level_size.x:
		for y in level_size.y:
			var pos := Vector2(x, y)
			erase_all_layers_at(pos)


func set_cell(pos: Vector2, type: TileType):
	var set_layer : TileMapLayer
	match type:
		TileType.GRASS:
			set_layer = grass_layer
		TileType.ROCK:
			set_layer = rock_layer
		TileType.WATER:
			set_layer = water_layer
		TileType.LAVA:
			set_layer = lava_layer
		TileType.PATH:
			set_layer = path_layer
	if type != TileType.PATH: set_layer.set_cell(pos, SOURCE_ID, _get_random_tile(type))
	
	for erase_layer in [grass_layer, rock_layer, water_layer, lava_layer, path_layer]:
		if erase_layer == set_layer: continue
		
		if has_tile(erase_layer, pos):
			if type == TileType.PATH: 
				var erase_type : TileType
				match erase_layer:
					grass_layer:
						erase_type = TileType.GRASS
					rock_layer:
						erase_type = TileType.ROCK
					water_layer:
						erase_type = TileType.WATER
					lava_layer:
						erase_type = TileType.LAVA
				set_layer.set_cell(pos, SOURCE_ID, _get_random_tile(erase_type, true))
			#print("Erased at ", pos, " from layer ", erase_layer.name, " for ", set_layer.name)
			erase_layer.erase_cell(pos)


func has_tile(tile_map_layer: TileMapLayer, map_pos: Vector2i) -> bool:
	return tile_map_layer.get_cell_source_id(map_pos) != -1
